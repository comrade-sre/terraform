resource "helm_release" "workload" {
  name = "awsdb"
  chart = "stable/mariadb"
  set {
    name = "dbuser"
    value = var.dbuser
  }
  set {
    name = "dbPassword"
    value = var.dbpass
  }
}
    
