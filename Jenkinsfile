pipeline {
    agent any
    tools {
                maven 'mvn39'
                } 
    environment {
        KUBECONFIG = credentials('rancher-cred-dev')
        NAMESPACE = 'default'
    }
    stages {
        stage('Build And Push to Artifactory') {
            steps {
                script {
                    sh '''
                        mvn clean package
                        ls -la target
                        docker build -t padamkiran/mytomcat:$BUILD_NUMBER .
                        cat ./mypassword.txt | docker login --username padamkiran --password-stdin
                        docker push padamkiran/mytomcat:$BUILD_NUMBER
                        docker rmi padamkiran/mytomcat:$BUILD_NUMBER
                        docker logout
                    '''
                }
            }
        }
        stage('Deploy TOMCAT Pod TO RANCHER CLUSTER') {
            steps {
                script {
                    sh '''
                        #kubectl --kubeconfig=$KUBECONFIG
                        export KUBECONFIG="${KUBECONFIG}"
                        kubectl apply -f ./yaml/deploy.yaml -n $NAMESPACE
                        kubectl set image deployment/tomcat-deployment tomcat=padamkiran/mytomcat:$BUILD_NUMBER -n $NAMESPACE                        
                        sleep 60s
                        kubectl get po -n $NAMESPACE
                    '''
                }
            }
        }
    }
}
