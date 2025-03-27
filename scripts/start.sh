#!/bin/bash
# ==========================================================
# start.sh - Script para iniciar todos los servicios
# ==========================================================
# Este script inicia todos los servicios necesarios:
# - Verifica que LocalStack esté en ejecución (o lo inicia)
# - Aplica la configuración de Terraform
# - Obtiene parámetros de SSM de LocalStack
# - Actualiza el archivo .env con los valores obtenidos
# - Inicia los servicios con Docker Compose

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directorio base (el directorio donde se encuentra este script)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
cd "$BASE_DIR" || exit 1

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}    Stock Advisor - Iniciando Servicios          ${NC}"
echo -e "${BLUE}=================================================${NC}"

# Función para verificar si un contenedor Docker está en ejecución
is_container_running() {
    if docker ps --format '{{.Names}}' | grep -q "^$1$"; then
        return 0
    else
        return 1
    fi
}

# Función para esperar a que LocalStack esté listo
wait_for_localstack() {
    echo -e "${BLUE}Esperando a que LocalStack esté listo...${NC}"
    max_attempts=30
    attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "running"'; then
            echo -e "${GREEN}LocalStack está listo.${NC}"
            return 0
        fi
        
        attempt=$((attempt+1))
        echo -e "${YELLOW}Esperando a LocalStack (intento $attempt de $max_attempts)...${NC}"
        sleep 2
    done
    
    echo -e "${RED}Tiempo de espera agotado para LocalStack.${NC}"
    return 1
}

# Verificar si LocalStack está en ejecución
if ! is_container_running "localstack"; then
    echo -e "${BLUE}Iniciando LocalStack...${NC}"
    
    # Iniciar LocalStack con Docker
    docker run -d --name localstack \
        -p 4566:4566 -p 4510-4559:4510-4559 \
        -e SERVICES=s3,sqs,iam,ec2,ssm,apigateway \
        -e DEBUG=0 \
        -e DATA_DIR=/tmp/localstack/data \
        -v "${PWD}/localstack-data:/tmp/localstack/data" \
        localstack/localstack:latest
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error al iniciar LocalStack.${NC}"
        exit 1
    fi
    
    # Esperar a que LocalStack esté listo
    wait_for_localstack
else
    echo -e "${GREEN}LocalStack ya está en ejecución.${NC}"
fi

# Aplicar la configuración de Terraform
echo -e "${BLUE}Aplicando configuración de Terraform...${NC}"
cd terraform || exit 1
terraform init -reconfigure

# Aplicar Terraform y capturar la salida
output_file="${BASE_DIR}/terraform/tf_output.txt"
terraform apply -auto-approve | tee "$output_file"

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo -e "${RED}Error al aplicar la configuración de Terraform.${NC}"
    exit 1
fi

echo -e "${GREEN}Configuración de Terraform aplicada exitosamente.${NC}"

# Obtener datos y parámetros
echo -e "${BLUE}Obteniendo parámetros de LocalStack...${NC}"

# Obtener el entorno de Terraform output
environment=$(terraform output -raw environment 2>/dev/null || echo "dev")

# Obtener parámetros SSM de LocalStack
backend_db_param_name=$(terraform output -raw backend_database_param_name 2>/dev/null || echo "/$environment/backend/database_url")
backend_service_url=$(terraform output -raw backend_service_url 2>/dev/null || echo "http://localhost:8080")

cd "$BASE_DIR" || exit 1

# Obtener valores de los parámetros
DATABASE_URL=$(aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameter --name "$backend_db_param_name" --with-decryption --query "Parameter.Value" --output text 2>/dev/null || echo "")
STOCK_API_URL=$(aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameter --name "/$environment/backend/stock_api_url" --query "Parameter.Value" --output text 2>/dev/null || echo "https://8j5baasof2.execute-api.us-west-2.amazonaws.com/production/swechallenge/list")
STOCK_AUTH_TKN=$(aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameter --name "/$environment/backend/stock_auth_token" --with-decryption --query "Parameter.Value" --output text 2>/dev/null || echo "")

# Si alguno de los valores críticos está vacío, advertir y usar valores por defecto
if [ -z "$DATABASE_URL" ]; then
    echo -e "${YELLOW}Advertencia: No se pudo obtener DATABASE_URL de SSM. Usando valor por defecto.${NC}"
    # Usar valor por defecto o solicitarlo al usuario
    echo -e "${YELLOW}Introduce la cadena de conexión a CockroachDB Serverless:${NC}"
    read -r DATABASE_URL
fi

if [ -z "$STOCK_AUTH_TKN" ]; then
    echo -e "${YELLOW}Advertencia: No se pudo obtener STOCK_AUTH_TKN de SSM. Usando valor por defecto.${NC}"
    # Usar valor por defecto o solicitarlo al usuario
    echo -e "${YELLOW}Introduce el token de autenticación para la API externa:${NC}"
    read -r STOCK_AUTH_TKN
fi

# Actualizar el archivo .env con los valores obtenidos
echo -e "${BLUE}Actualizando archivo .env con los valores obtenidos...${NC}"
cat > docker/.env << EOF
# ======================================================
# Variables de entorno para Docker Compose
# Actualizado automáticamente por start.sh
# ======================================================

# ======================================================
# CONFIGURACIÓN DE PUERTOS
# ======================================================
BACKEND_PORT=8080
FRONTEND_PORT=5173

# ======================================================
# CONFIGURACIÓN DEL BACKEND
# ======================================================
DATABASE_URL=${DATABASE_URL}
STOCK_API_URL=${STOCK_API_URL}
STOCK_AUTH_TKN=${STOCK_AUTH_TKN}
SYNC_MAX_ITERATIONS=100
SYNC_TIMEOUT=60
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://frontend:5173,http://127.0.0.1:5173

# ======================================================
# CONFIGURACIÓN DEL FRONTEND
# ======================================================
VITE_API_BASE_URL=${backend_service_url}
VITE_DEFAULT_LANGUAGE=EN

# ======================================================
# RUTAS DE ARCHIVOS
# ======================================================
RECOMMENDATION_FACTORS_PATH=../repositories/stock-advisor-backend/recommendation_factors.json
EOF

echo -e "${GREEN}Archivo .env actualizado exitosamente.${NC}"

# Iniciar los servicios con Docker Compose
echo -e "${BLUE}Iniciando servicios con Docker Compose...${NC}"
cd docker || exit 1
docker-compose down
docker-compose up -d --build

if [ $? -ne 0 ]; then
    echo -e "${RED}Error al iniciar los servicios con Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}¡Servicios iniciados exitosamente!${NC}"
echo -e "${BLUE}Accede a las aplicaciones:${NC}"
echo -e "${BLUE}- Frontend: http://localhost:${FRONTEND_PORT:-5173}${NC}"
echo -e "${BLUE}- API Backend: http://localhost:${BACKEND_PORT:-8080}${NC}"
echo -e "${BLUE}- API Swagger: http://localhost:${BACKEND_PORT:-8080}/swagger/index.html${NC}"
echo -e "${BLUE}- LocalStack Dashboard: http://localhost:8080${NC}"
cd "$BASE_DIR" || exit 1