resource "docker_image" "postgres" {
  name = "postgres:16-alpine"
}

resource "docker_container" "db" {
  name  = "bd-${terraform.workspace}"
  image = docker_image.postgres.image_id
  env   = ["POSTGRES_PASSWORD=postgres"]

  ports {
    internal = 5432
    external = var.db_port[terraform.workspace]
  }

  networks_advanced {
    name = docker_network.env_network.name
  }
}