node {
   def tag
   tag = 'ubuntu'
//    tag = 'macos'
   stage('Preparation') {
     checkout scm
     sh "git rev-parse --short HEAD > .git/commit-id"
     commit_id = readFile('.git/commit-id').trim()
   }
   stage('docker build/push') {
     docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
       def app = docker.build("marcusveloso/jenkins-docker:${tag}", '.').push()
     }
   }
}