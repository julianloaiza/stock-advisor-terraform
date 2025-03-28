## stock-advisor-terraform

Este repositorio contiene la configuración de infraestructura como código (IaC) para el proyecto **Stock Advisor**, desplegado en AWS utilizando **Terraform**. El objetivo principal es alojar tanto el backend (API en Go) como el frontend (aplicación Vue.js) de manera segura y escalable. Además, se aprovechan servicios de AWS como ECS Fargate, ALB, S3 y Parameter Store para gestionar la conexión a una base de datos externa (CockroachDB).

![Diagrama de Arquitectura](diagram.png)

Este diagrama ilustra la arquitectura de alto nivel del proyecto **Stock Advisor**, mostrando la integración de servicios de AWS como ECS Fargate, ALB, S3 y Parameter Store con una base de datos externa CockroachDB.
---

### Estructura de Directorios

```
stock-advisor-terraform/
├── environments/
│   └── develop/
│       ├── certs/
│       │   └── ca_cert.pem (gitignore)
│       ├── main.tf
│       ├── outputs.tf
│       ├── terraform.tfvars (gitignore)
│       └── variables.tf
└── modules/
    ├── backend/
    │   ├── ecr.tf
    │   ├── ecs_cluster.tf
    │   ├── ecs_service.tf
    │   ├── load_balancer.tf
    │   ├── outputs.tf
    │   ├── task_definition.tf
    │   └── variables.tf
    ├── database/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── frontend/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    ├── networking/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── security/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

**`environments/develop`**  
- **certs**: Carpeta donde se almacena el certificado CA de CockroachDB (`ca_cert.pem`). Está ignorada en el repositorio por seguridad.  
- **main.tf**: Archivo principal que invoca los módulos (networking, security, backend, etc.).  
- **outputs.tf**: Expone las salidas de cada módulo, con información clave (URLs, ARNs, etc.).  
- **terraform.tfvars**: Archivo para credenciales y valores sensibles o específicos del entorno (gitignore).  
- **variables.tf**: Variables requeridas por el entorno (`aws_region`, credenciales, etc.).

**`modules`**  
Cada carpeta es un componente modular, reutilizable en distintos entornos:

- **backend**: Despliegue del API en Go:
  - Repositorio ECR, ECS Cluster & Task Definition en Fargate
  - Servicio ECS con balanceo de carga mediante ALB
- **database**: Configuración y parámetros de la base de datos (CockroachDB) almacenados en AWS SSM Parameter Store.
- **frontend**: Hosting estático en S3 para la aplicación Vue.js.
- **networking**: Configuración de VPC, subnets públicas/privadas, NAT Gateway, etc.
- **security**: Grupos de seguridad e IAM para roles y políticas mínimas.

---

### Requisitos

- **Terraform** v1.11.3 o superior  
- **AWS CLI** configurado con credenciales válidas  
- Permisos para crear recursos en AWS (ECS, ALB, S3, etc.)

> Nota: La configuración ha sido probada con versiones más recientes de Terraform (v1.2 o superior). Con v1.11.3 debería funcionar, pero si experimentas algún problema, considera actualizar a una versión más reciente.

---

### Uso

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/tu-usuario/stock-advisor-terraform.git
   ```

2. **Acceder al entorno (por ejemplo, `develop`):**
   ```bash
   cd stock-advisor-terraform/environments/develop
   ```

3. **Inicializar Terraform:**
   ```bash
   terraform init
   ```

4. **Revisar los planes de despliegue:**
   ```bash
   terraform plan
   ```

5. **Aplicar los cambios:**
   ```bash
   terraform apply
   ```
   Escribe `yes` cuando se solicite confirmación.

6. **Destruir la infraestructura (opcional):**
   ```bash
   terraform destroy
   ```
   Asegúrate de respaldar datos sensibles antes de destruir los recursos.

---

### Consideraciones

- El archivo `terraform.tfvars` (ignoradado por `.gitignore`) debe contener valores sensibles (por ejemplo, `aws_access_key`, `aws_secret_key`) y la cadena de conexión a CockroachDB.  
- El archivo `ca_cert.pem` no se sube al repositorio por motivos de seguridad.
- Para compilar y subir imágenes de Docker al repositorio ECR, es necesario usar el AWS CLI (ej. `aws ecr get-login-password`) y Docker.

---

### Próximos Pasos / Mejoras

- Configurar **HTTPS** en el ALB con un certificado de ACM.  
- Agregar **CloudFront** para servir el frontend de forma más segura y eficiente.  
- Implementar políticas de **Auto Scaling** para ECS Fargate.  
- Añadir un **pipeline CI/CD** (AWS CodePipeline, GitHub Actions, etc.) para despliegues automatizados.