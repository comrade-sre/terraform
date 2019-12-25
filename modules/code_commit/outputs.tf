output "ssh" {
  value = module.code_comit.aws_codecommit_repository.comrade_repo.clone_url_ssh
}
output "http" {
  value = module.code_commit.aws_codecommit_repository.comrade_repo.clone_url_http
}
