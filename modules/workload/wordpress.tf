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
  depends_on = [helm_release.ingress]
}

    
resource "helm_release" "ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  version = "1.27.0"
}
