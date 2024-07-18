variable "namespace" {
  default = "b2metric"
}

variable "mysql_secret_name" {
  default = "mysql-secret"
}

variable "mysql_secret_data" {
  type = map(string)
  default = {
    MYSQL_DATABASE     = "cGhvbmVib29r"
    MYSQL_PASSWORD     = "bm9lYXN5d2F5b3V0"
    MYSQL_ROOT_PASSWORD = "YWxsaXN3ZWxs"
    MYSQL_USER         = "ZXJjYW4="
  }
}

variable "servers_secret_name" {
  default = "servers-secret"
}

variable "servers_secret_data" {
  type = map(string)
  default = {
    password = "noeasywayout"
  }
}

variable "servers_config_map_name" {
  default = "servers-cm"
}

variable "servers_config_map_data" {
  type = map(string)
  default = {
    MYSQL_DATABASE = "phonebook"
    MYSQL_DATABASE_HOST = "mysql-service"
    MYSQL_USER = "ercan"
  }
}

variable "mysql_pv_name" {
  default = "mysql-pv-volume"
}

variable "mysql_storage_class_name" {
  default = "manual"
}

variable "mysql_pv_storage" {
  default = "2Gi"
}

variable "mysql_access_mode" {
  default = "ReadWriteOnce"
}

variable "mysql_host_path" {
  default = "/mnt/data"
}

variable "mysql_pvc_name" {
  default = "mysql-pv-claim"
}

variable "mysql_pvc_storage" {
  default = "2Gi"
}

variable "mysql_deployment_name" {
  default = "mysql-deploy"
}

variable "mysql_replica_count" {
  default = 1
}

variable "mysql_app_name" {
  default = "mysql-deploy"
}

variable "mysql_image" {
  default = "mysql:5.7"
}

variable "mysql_container_name" {
  default = "mysql"
}

variable "mysql_container_port" {
  default = 3306
}

variable "mysql_volume_mount_path" {
  default = "/var/lib/mysql"
}

variable "mysql_volume_name" {
  default = "mysql-pv-storage"
}

variable "mysql_service_name" {
  default = "mysql-service"
}

variable "mysql_service_port" {
  default = 3306
}

variable "mysql_target_port" {
  default = 3306
}

variable "resultserver_deployment_name" {
  default = "resultserver-deployment"
}

variable "resultserver_app_name" {
  default = "phonebook"
}

variable "resultserver_replica_count" {
  default = 1
}

variable "resultserver_match_labels" {
  default = "phonebook-result"
}

variable "resultserver_container_name" {
  default = "resultserver"
}

variable "resultserver_image" {
  default = "ercandevops/resultserver:2.1.1"
}

variable "resultserver_secret_key" {
  default = "password"
}

variable "resultserver_container_port" {
  default = 80
}

variable "resultserver_service_name" {
  default = "resultserver-service"
}

variable "resultserver_selector_app" {
  default = "phonebook-result"
}

variable "resultserver_service_port" {
  default = 80
}

variable "resultserver_target_port" {
  default = 80
}

variable "resultserver_node_port" {
  default = 30002
}

variable "webserver_deployment_name" {
  default = "webserver-deployment"
}

variable "webserver_app_name" {
  default = "phonebook"
}

variable "webserver_replica_count" {
  default = 1
}

variable "webserver_match_labels" {
  default = "phonebook"
}

variable "webserver_container_name" {
  default = "webserver"
}

variable "webserver_image" {
  default = "ercandevops/webserver:2.1.1"
}

variable "webserver_secret_key" {
  default = "password"
}

variable "webserver_container_port" {
  default = 80
}

variable "webserver_service_name" {
  default = "webserver-service"
}

variable "webserver_selector_app" {
  default = "phonebook"
}

variable "webserver_service_port" {
  default = 80
}

variable "webserver_target_port" {
  default = 80
}

variable "webserver_node_port" {
  default = 30001
}
