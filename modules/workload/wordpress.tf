resource "helm_release" "workload" {
  name = "awsdb"
  chart = "stable/wordpress"
  version = "8.1.0"
  set {
    name = "wordpressUsername" 
    value = var.wp_user
  }
  set {
    name = "wordpressPassword"
    value = var.wp_pass    
  }
}

    
