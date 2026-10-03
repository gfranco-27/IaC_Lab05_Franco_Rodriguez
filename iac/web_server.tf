resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "web_server_dev" {
  name  = "web-${terraform.workspace}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.web_server_port[terraform.workspace]
  }

  networks_advanced {
    name = docker_network.env_network.name
  }
}