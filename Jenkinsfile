#!groovy
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import groovy.transform.Field

//def jenkins = 'jenkins-slave'
node {
      // checkout()
   build()
  //     docker()
  //     pushregistry() 
       //deploy()
}



// ################# ####Checking out code from GITHUB #################
def checkout () {
    stage 'Checkout'
    node {
        echo 'Building ...........'
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'git@github.dx.utc.com:VERMARAH1/springbootBackend.git']]])
       // sh """sed -i 's/Build number/Build number ${env.BUILD_ID}/g' index.html """
          }

      }  

def build() {
    stage 'Build'
        node {
           echo 'Building application ..'
            sh ''' ./mvnw clean install -DskipTests'''

//       make build
//       make build-rpm'''
        }
} 
    
    def docker () {
    stage 'Docker Build'
   node {
    def dockerfile = 'Dockerfile'
    def customImage = docker.build("sample-backend:${env.BUILD_ID}", "-f ${dockerfile} .") 
}
}

def pushregistry () {
  stage 'Docker Push'

node {
    docker.withRegistry('https://dxpregistry.azurecr.io', 'jenkins-azure-sp') {

        def customImage = docker.build("sample-backend:${env.BUILD_ID}") 

        /* Push the container to the custom Registry */
        customImage.push()
    }
    
    }
  }
  
  def deploy() {

 stage ' Deploy Kubernetes '

 node {
  sh """sed -i 's/latest/${env.BUILD_ID}/g' k8/sample-backend-deployment.yaml """

acsDeploy(azureCredentialsId: 'jenkins-azure-service',
          resourceGroupName: 'UTDX_AKS',
          containerService: 'UTDXAKS | AKS',
          sshCredentialsId: 'jenkins-azure-aks-cluster',
          configFilePaths: 'k8/sample-backend*.yaml',
          enableConfigSubstitution: true,
          
          // Kubernetes
         // secretName: 'dxmailer',
         // secretNamespace: 'dxmailer',
          
          // Docker Swarm
          //swarmRemoveContainersFirst: true,
          
          // DC/OS Marathon
          // dcosDockerCredentialsPath: '<dcos-credentials-path>',
          
          containerRegistryCredentials: [
              [credentialsId: 'jenkins-azure-sp', url: 'https://dxpregistry.azurecr.io']
          ])
        

 }

  }
