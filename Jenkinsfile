def label = "buildpod.${env.JOB_NAME}.${env.BUILD_NUMBER}".replace('-', '_').replace('/', '_')
podTemplate(label: label, containers: [
  containerTemplate(name: 'maven', image: 'maven:3.6.2-jdk-8', command: 'cat', ttyEnabled: true),
  containerTemplate(
    name: 'docker',
    image: 'docker',
    command: 'cat',
    ttyEnabled: true,
    envVars: [
      envVar(key: 'TZ', value: 'Europe/Madrid')
    ],
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
        def image = docker.build("806950227484.dkr.ecr.eu-west-3.amazonaws.com/hello:b-${BUILD_NUMBER}")
        docker.withRegistry('https://806950227484.dkr.ecr.eu-west-3.amazonaws.com', 'ecr:eu-west-3:terraform_role') {
          image.push()
        }
        // sh """
        // docker build -t 806950227484.dkr.ecr.eu-west-3.amazonaws.com/podinfo:${BUILD_NUMBER} .
        // docker push 806950227484.dkr.ecr.eu-west-3.amazonaws.com/podinfo:${BUILD_NUMBER}
        // """
      }
    }
  }
}