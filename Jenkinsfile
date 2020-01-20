def label = "buildpod.${env.JOB_NAME}.${env.BUILD_NUMBER}".replace('-', '_').replace('/', '_')
podTemplate(label: label, containers: [
  containerTemplate(
    name: 'maven',
    image: 'maven:3.6.2-jdk-8',
    command: 'cat',
    ttyEnabled: true
  ),
  containerTemplate(
    name: 'docker',
    image: 'docker',
    command: 'cat',
    ttyEnabled: true
  )
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node(label) {
    def myRepo = checkout scm
    stage('Test') {
      try {
        container('maven') {
          sh """mvn test"""
        }
      }
      catch (exc) {
        println "Failed to test - ${currentBuild.fullDisplayName}"
      }
    }
    stage('Build') {
      try {
        container('maven') {
          sh """mvn clean package"""
        }
      }
      catch (exc) {
        println "Failed to build - ${currentBuild.fullDisplayName}"
      }
    }
    stage('Create Docker images') {
      container('docker') {
        def image = docker.build("806950227484.dkr.ecr.eu-central-1.amazonaws.com/hello:b-${BUILD_NUMBER}")
        docker.withRegistry('https://806950227484.dkr.ecr.eu-central-1.amazonaws.com', 'ecr:eu-central-1:terraform_role') {
          image.push()
        }
      }
    }
  }
}