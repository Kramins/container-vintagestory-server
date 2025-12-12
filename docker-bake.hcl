variable "repo" {
    default = "kramins"
}

variable "container-name" {
    default = "vintagestory"
}

variable "versions" {
    default = ["1.21.5"]
}

variable "distros" {
    default = ["ubuntu"]
}

variable "default-distro" {
    default = "ubuntu"
}

group "default" {
    targets = ["vintagestory"]
}

target "vintagestory" {
    matrix = {
        VS_VERSION = versions
        DISTRO = distros
    }

    name        = "vintagestory-${DISTRO}-${replace(VS_VERSION, ".", "-")}-server"
    dockerfile  = "./Dockerfile.${DISTRO}"
    platforms   = ["linux/amd64"]

    args = {
        VS_VERSION = VS_VERSION
    }

    tags = flatten([

  # Full version with distro
  [format("${repo}/${container-name}:%s-%s", VS_VERSION, DISTRO)],

  # Full version with default distro
  DISTRO == default-distro ? [format("${repo}/${container-name}:%s", VS_VERSION)] : [],

  # Minor (X.Y) with distro
  length(split(".", VS_VERSION)) >= 2 ?
    [format("${repo}/${container-name}:%s.%s-%s",
        split(".", VS_VERSION)[0],
        split(".", VS_VERSION)[1],
        DISTRO
     )]
    : [],

  # Minor (X.Y) with default distro
  DISTRO == default-distro && length(split(".", VS_VERSION)) >= 2 ?
    [format("${repo}/${container-name}:%s.%s",
        split(".", VS_VERSION)[0],
        split(".", VS_VERSION)[1]
     )]
    : [],

  # Major (X) with distro
  length(split(".", VS_VERSION)) >= 1 ?
    [format("${repo}/${container-name}:%s-%s", split(".", VS_VERSION)[0], DISTRO)]
    : [],

  # Major (X) with default distro
  DISTRO == default-distro && length(split(".", VS_VERSION)) >= 1 ?
    [format("${repo}/${container-name}:%s", split(".", VS_VERSION)[0])]
    : [],

  # latest with distro
  VS_VERSION == versions[0] ?
    [format("${repo}/${container-name}:latest-%s", DISTRO)]
    : [],

  # latest with default distro
  DISTRO == default-distro && VS_VERSION == versions[0] ?
    ["${repo}/${container-name}:latest"]
    : []
])

}
