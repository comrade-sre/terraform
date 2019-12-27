 properties([parameters([
  string(defaultValue: 'eks', description: 'what target will we choose for applying', name: 'target'),
  choice(name: 'action', choices: ['destroy', 'apply'], description: 'will we destroy or build infrastructure')
  ])])
node('master') {

  stage('initialization') {
    git([url: 'https://github.com/comrade-sre/terraform/', branch: 'master', credentialsId: 'dfcd622b-7297-4eb5-9af0-00a76e66a03b'])
    sh """cp -r $HOME/{.env,.aws} `pwd` """
    sh "docker build -t mentoring -f Dockerfile ."
  }
  stage('terraform') {
        sh "docker run --env-file .env mentoring ${params.action} -target=module.${params.target}"
  }
  stage('clean') {
    cleanWs()
    sh """ docker ps -a | awk 'NR > 1 {if (\$2 ~ /mentoring/)print \$1}' | xargs -I {} docker rm {} """
    sh "docker rmi mentoring"
  }
}
