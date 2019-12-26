output "ssh" {
  value = aws_codecommit_repository.comrade_repo.clone_url_ssh
}
output "http" {
  value = aws_codecommit_repository.comrade_repo.clone_url_http
}

