# Lab-05 Terraform y Docker
 
Despliegue con Terraform (provider `kreuzwerker/docker`) de dos entornos, **dev** y **qa**. Cada entorno tiene frontend, backend y bd y se separan con workspaces.
 
## Arquitectura
 
| Entorno | Servicio | Contenedor | Imagen | Puerto (host:contenedor) |
|---------|----------|------------|--------|--------------------------|
| dev | Frontend | `web-dev` | `nginx:latest` | 4001:80 |
| dev | Backend (API Hello World) | `api-dev` | `node:20-alpine` | 4002:3000 |
| dev | Base de datos | `bd-dev` | `postgres:16-alpine` | 4003:5432 |
| qa | Frontend | `web-qa` | `nginx:latest` | 5001:80 |
| qa | Backend (API Hello World) | `api-qa` | `node:20-alpine` | 5002:3000 |
| qa | Base de datos | `bd-qa` | `postgres:16-alpine` | 5003:5432 |
 
Cada entorno usa su propia red de Docker (`net-dev` y `net-qa`), así los contenedores de un entorno no se ven con los del otro.
 
Todas las imágenes se descargan de Docker Hub. La API es un servidor HTTP de Node que responde `Hello World` en el puerto 3000.
 
## Estructura
 
```
iac/
├── providers.tf       # provider docker 4.6.0
├── variables.tf       # puertos por workspace
├── terraform.tfvars   # valores de los puertos
├── network.tf         # red por entorno
├── database.tf        # postgres
├── api.tf             # api hello world (node)
└── web_server.tf      # frontend (nginx)
```
 
## Requisitos
 
- Terraform
- Docker Desktop corriendo (en Windows, con WSL2)
## Uso
 
```powershell
cd iac
terraform init
 
# dev
terraform workspace new dev        # o: terraform workspace select dev
terraform apply -auto-approve
 
# qa
terraform workspace new qa         # o: terraform workspace select qa
terraform apply -auto-approve
```
 
Los puertos solo están definidos para `dev` y `qa`.
 
## Verificación
 
```powershell
docker ps --format "table {{.Names}}\t{{.Ports}}"
curl http://localhost:4001   # web-dev
curl http://localhost:4002   # api-dev
curl http://localhost:5001   # web-qa
curl http://localhost:5002   # api-qa
```
 
## Eliminar los recursos
 
```powershell
terraform workspace select dev
terraform destroy -auto-approve
terraform workspace select qa
terraform destroy -auto-approve
```
 
## Documentación utilizada
 
- [Provider kreuzwerker/docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [Terraform workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)
- [Tutorial Terraform + Docker](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-build)
- [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)