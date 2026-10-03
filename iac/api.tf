resource "docker_image" "node" {
  name = "node:20-alpine"
}

resource "docker_container" "api" {
  name    = "api-${terraform.workspace}"
  image   = docker_image.node.image_id
  command = ["node", "-e", "require('http').createServer((q,r)=>r.end('Hello World')).listen(3000)"]

  ports {
    internal = 3000
    external = var.api_port[terraform.workspace]
  }

  networks_advanced {
    name = docker_network.env_network.name
  }
}