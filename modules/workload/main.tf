resource "helm_release" "workload" {
  name = "awsdb"
  chart = "stable/mariadb"
  version = "7.3.1"
  set {
    name = "dbuser"
    value = var.dbuser
  }
  set {
    name = "dbPassword"
    value = var.dbpass
  }
}
    
