# ======================================================
# Variables de entorno para Docker Compose
# Este archivo será actualizado automáticamente por scripts/start.sh
# con valores obtenidos de LocalStack SSM Parameters
# ======================================================

# ======================================================
# CONFIGURACIÓN DE PUERTOS
# ======================================================
# Puerto para la API Backend - API REST para datos de acciones
BACKEND_PORT=8080

# Puerto para la aplicación Frontend - Interfaz web
FRONTEND_PORT=5173

# ======================================================
# CONFIGURACIÓN DEL BACKEND
# ======================================================
# URL de conexión a la base de datos CockroachDB Serverless
# Será sobreescrita por el valor en SSM Parameter Store de LocalStack
DATABASE_URL=postgresql://usuario:contraseña@host:puerto/basedatos?sslmode=disable

# URL de la API externa para datos de acciones
# Será sobreescrita por el valor en SSM Parameter Store de LocalStack
STOCK_API_URL=https://8j5baasof2.execute-api.us-west-2.amazonaws.com/production/swechallenge/list

# Token de autenticación para la API externa
# Será sobreescrito por el valor en SSM Parameter Store de LocalStack
STOCK_AUTH_TKN=token_placeholder

# Número máximo de iteraciones para sincronización de datos
SYNC_MAX_ITERATIONS=100

# Tiempo límite en segundos para operaciones de sincronización
SYNC_TIMEOUT=60

# Orígenes permitidos para peticiones CORS
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://frontend:5173,http://127.0.0.1:5173

# ======================================================
# CONFIGURACIÓN DEL FRONTEND
# ======================================================
# URL de la API Backend a la que el Frontend se conectará
# Será sobreescrita con la URL generada por la simulación en LocalStack
VITE_API_BASE_URL=http://localhost:8080

# Idioma predeterminado para la interfaz de usuario del Frontend
VITE_DEFAULT_LANGUAGE=EN

# ======================================================
# RUTAS DE ARCHIVOS
# ======================================================
# Ruta al archivo recommendation_factors.json para el backend
RECOMMENDATION_FACTORS_PATH=../repositories/stock-advisor-backend/recommendation_factors.json