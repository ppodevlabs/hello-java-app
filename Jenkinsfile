def label = "buildpod.${env.JOB_NAME}.${env.BUILD_NUMBER}".replace('-', '_').replace('/', '_')
podTemplate(label: label, containers: [
  containerTemplate(name: 'maven', image: 'maven:3.6.2-jdk-8', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true)
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
  node(label) {
    stage('Test') {
      try {
        container('maven') {
          sh "mvn test"
        }
      }
      catch (exc) {
        println "Failed to test - ${currentBuild.fullDisplayName}"
      }
    }
    stage('Create Docker images') {
      container('docker') {
        sh """
        docker build -t 806950227484.dkr.ecr.eu-west-3.amazonaws.com/podinfo:${BUILD_NUMBER} .
        docker push 806950227484.dkr.ecr.eu-west-3.amazonaws.com/podinfo:${BUILD_NUMBER}
        """
      }
    }
  }
}