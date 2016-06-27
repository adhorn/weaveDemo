job "webservice" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "10s"
    max_parallel = 1
  }

  group "db" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    task "rabbitmq" {
      driver = "docker"

      config {
        image = "rabbitmq:3"
        network_mode = "backoffice"
      }

      service {
        name = "${TASKGROUP}-rabbitmq"
        tags = ["db"]
      }

      resources {
        cpu = 500 # 500 Mhz
        memory = 256 # 256MB
        network {
          mbits = 10
        }
      }
    }
  }
}