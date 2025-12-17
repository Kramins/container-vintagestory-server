variable "registry" {
  default = "ghcr.io"
}

variable "repo" {
  default = "kramins"
}

variable "container-name" {
  default = "vintagestory-devcontainer"
}

variable "versions" {
  default = ["1.21.6"]
}

variable "distros" {
  default = ["ubuntu"]
}

variable "default-distro" {
  default = "ubuntu"
}

group "default" {
  targets = ["vintagestory-devcontainer"]
}

target "vintagestory-devcontainer" {
  matrix = {
    VS_VERSION = versions
  }

  name        = "vintagestory-devcontainer-${replace(VS_VERSION, ".", "-")}-server"
  dockerfile  = "./Dockerfile.devcontainer.ubuntu"
  platforms   = ["linux/amd64"]

  args = {
    VS_VERSION = VS_VERSION
  }

  tags = flatten([

  # Full version
  [format("${registry}/${repo}/${container-name}:%s", VS_VERSION)],

  # Minor (X.Y)
  [format("${registry}/${repo}/${container-name}:%s.%s",
        split(".", VS_VERSION)[0],
        split(".", VS_VERSION)[1]
     )],

  # Major (X) 
  [format("${registry}/${repo}/${container-name}:%s", split(".", VS_VERSION)[0])],

  # latest
  ["${registry}/${repo}/${container-name}:latest"],

])

}
