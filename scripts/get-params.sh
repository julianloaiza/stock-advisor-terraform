#!/bin/bash
# ==========================================================
# get-params.sh - Script para obtener parámetros de SSM
# ==========================================================
# Este script obtiene parámetros de SSM de LocalStack
# Útil para depuración o para ejecutar manualmente

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
echo -e "${BLUE}    Obteniendo Parámetros de LocalStack SSM      ${NC}"
echo -e "${BLUE}=================================================${NC}"

# Verificar si se proporciona un entorno, de lo contrario usar "dev"
environment=${1:-dev}

echo -e "${BLUE}Entorno: ${environment}${NC}"

# Obtener el prefijo del parámetro
prefix="/${environment}"

# Listar todos los parámetros en el prefix
echo -e "${BLUE}Listando todos los parámetros en ${prefix}...${NC}"
aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameters-by-path \
    --path "${prefix}" \
    --recursive \
    --query "Parameters[*].[Name]" \
    --output text

echo -e "${BLUE}\nMostrando valores de parámetros específicos:${NC}"

# Función para mostrar un parámetro
show_parameter() {
    param_name=$1
    with_decryption=${2:-false}
    
    echo -e "${YELLOW}${param_name}:${NC}"
    
    if [ "$with_decryption" = true ]; then
        value=$(aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameter \
            --name "${param_name}" \
            --with-decryption \
            --query "Parameter.Value" \
            --output text 2>/dev/null)
    else
        value=$(aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameter \
            --name "${param_name}" \
            --query "Parameter.Value" \
            --output text 2>/dev/null)
    fi
    
    if [ -n "$value" ]; then
        echo -e "${GREEN}${value}${NC}"
    else
        echo -e "${RED}No se pudo obtener el valor.${NC}"
    fi
    
    echo ""
}

# Mostrar parámetros comunes
show_parameter "${prefix}/backend/database_url" true
show_parameter "${prefix}/backend/stock_api_url"
show_parameter "${prefix}/backend/stock_auth_token" true

# Preguntar si quiere listar todos los parámetros con sus valores
echo -e "${YELLOW}¿Quieres listar todos los parámetros con sus valores? (s/n)${NC}"
read -r response

if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
    echo -e "${BLUE}\nListando todos los valores de parámetros:${NC}"
    
    # Obtener lista de todos los parámetros
    parameters=$(aws --endpoint-url=http://localhost:4566 --profile localstack ssm get-parameters-by-path \
        --path "${prefix}" \
        --recursive \
        --query "Parameters[*].Name" \
        --output text)
    
    # Iterar sobre cada parámetro y mostrar su valor
    for param in $parameters; do
        # Determinar si es un parámetro seguro (contiene "token", "password", etc.)
        if [[ "$param" == *"token"* || "$param" == *"password"* || "$param" == *"secret"* || "$param" == *"database_url"* ]]; then
            show_parameter "$param" true
        else
            show_parameter "$param"
        fi
    done
fi

echo -e "${GREEN}¡Completado!${NC}"