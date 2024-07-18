provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "b2metric" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "mysql" {
  metadata {
    name = var.mysql_secret_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  data = var.mysql_secret_data
}

resource "kubernetes_secret" "servers" {
  metadata {
    name = var.servers_secret_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  data = var.servers_secret_data
}

resource "kubernetes_config_map" "servers" {
  metadata {
    name = var.servers_config_map_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  data = var.servers_config_map_data
}

resource "kubernetes_persistent_volume" "mysql" {
  metadata {
    name = var.mysql_pv_name
  }

  spec {
    storage_class_name = var.mysql_storage_class_name
    capacity = {
      storage = var.mysql_pv_storage
    }
    access_modes = [var.mysql_access_mode]

    persistent_volume_source {
      host_path {
        path = var.mysql_host_path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "mysql" {
  metadata {
    name = var.mysql_pvc_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  spec {
    storage_class_name = var.mysql_storage_class_name

    resources {
      requests = {
        storage = var.mysql_pvc_storage
      }
    }

    access_modes = [var.mysql_access_mode]
  }
}

resource "kubernetes_deployment" "mysql" {
  metadata {
    name = var.mysql_deployment_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  spec {
    replicas = var.mysql_replica_count

    selector {
      match_labels = {
        app = var.mysql_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.mysql_app_name
        }
      }

      spec {
        container {
          image = var.mysql_image
          name  = var.mysql_container_name

          env_from {
            secret_ref {
              name = kubernetes_secret.mysql.metadata[0].name
            }
          }

          port {
            container_port = var.mysql_container_port
          }

          volume_mount {
            mount_path = var.mysql_volume_mount_path
            name       = var.mysql_volume_name
          }
        }

        volume {
          name = var.mysql_volume_name

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mysql.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = var.mysql_service_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  spec {
    selector = {
      app = var.mysql_app_name
    }

    port {
      port        = var.mysql_service_port
      target_port = var.mysql_target_port
    }
  }
}

resource "kubernetes_deployment" "resultserver" {
  metadata {
    name = var.resultserver_deployment_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
    labels = {
      app = var.resultserver_app_name
    }
  }

  spec {
    replicas = var.resultserver_replica_count

    selector {
      match_labels = {
        app = var.resultserver_match_labels
      }
    }

    template {
      metadata {
        labels = {
          app = var.resultserver_match_labels
        }
      }

      spec {
        container {
          name  = var.resultserver_container_name
          image = var.resultserver_image

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.servers.metadata[0].name
                key  = var.resultserver_secret_key
              }
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.servers.metadata[0].name
            }
          }

          port {
            container_port = var.resultserver_container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "resultserver" {
  metadata {
    name = var.resultserver_service_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  spec {
    selector = {
      app = var.resultserver_selector_app
    }

    port {
      port        = var.resultserver_service_port
      target_port = var.resultserver_target_port
      node_port   = var.resultserver_node_port
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "webserver" {
  metadata {
    name = var.webserver_deployment_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
    labels = {
      app = var.webserver_app_name
    }
  }

  spec {
    replicas = var.webserver_replica_count

    selector {
      match_labels = {
        app = var.webserver_match_labels
      }
    }

    template {
      metadata {
        labels = {
          app = var.webserver_match_labels
        }
      }

      spec {
        container {
          name  = var.webserver_container_name
          image = var.webserver_image

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.servers.metadata[0].name
                key  = var.webserver_secret_key
              }
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.servers.metadata[0].name
            }
          }

          port {
            container_port = var.webserver_container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "webserver" {
  metadata {
    name = var.webserver_service_name
    namespace = kubernetes_namespace.b2metric.metadata[0].name
  }

  spec {
    selector = {
      app = var.webserver_selector_app
    }

    port {
      port        = var.webserver_service_port
      target_port = var.webserver_target_port
      node_port   = var.webserver_node_port
    }

    type = "NodePort"
  }
}
