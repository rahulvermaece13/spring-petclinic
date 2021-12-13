#!groovy
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovy.transform.Field

node {
      checkout()
      build()
      test()
      junit()
      docker()
      app()
// pushregistry() 
// deploy()
//  run()
    
}



// ################# ####Checking out code from GITHUB #################
def checkout () {
    stage 'Checkout'
    node {
        echo 'Building ...........'
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/rahulvermaece13/spring-petclinic.git']]])
          }

      }  

def build() {
    stage 'Build'
        node {
           echo 'Building application ..'
            sh '''./mvnw clean install -DskipTests'''

        }
} 

def test() {
    stage 'Test'
        node {
           echo 'Running test ..'
            sh '''./mvnw test'''

        }
} 
    
    
    def junit() {
  stage 'Integration Test'
      node {
      echo 'Running integration Test ..'
      junit 'target/surefire-reports/*.xml'
      }
    }
    
    def docker () {
    stage 'Docker Build'
   node {
    def dockerfile = 'Dockerfile'
    def customImage = docker.build("j-demo:${env.BUILD_ID}", "-f ${dockerfile} .") 
}
}



def pushregistry () {
  stage 'Docker Push'

node {
    docker.withRegistry('https://jrepo.domain.com', 'j-credentails') {

        def customImage = docker.build("j-demo:${env.BUILD_ID}") 

        /* Push the container to the custom Registry */
        customImage.push()
    }
    
    }
  }
  
  def deploy() {

 stage ' Deploy Kubernetes '

 node {
  sh """sed -i 's/latest/${env.BUILD_ID}/g' k8/jdemo-backend-deployment.yaml """

acsDeploy(azureCredentialsId: 'jenkins-azure-service',
          resourceGroupName: 'J_AKS',
          containerService: 'J | AKS',
          sshCredentialsId: 'jenkins-azure-aks-cluster',
          configFilePaths: 'k8/jdemo-backend*.yaml',
          enableConfigSubstitution: true,
          
 
          containerRegistryCredentials: [
              [credentialsId: 'j-credentails', url: 'https://jrepo.domain.com']
          ])
        

 }
 
  }
  
  def app() {
    stage 'Run'
        node {
           echo 'Running test ..'
            sh '''j-demo ; docker rm j-demo ; docker run -d -p 80:8080 --name j-demo   j-demo'''

        }
} 
   
