resource "docker_network" "env_network" {
  name = "net-${terraform.workspace}"
}