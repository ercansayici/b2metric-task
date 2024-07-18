pipeline {
    agent any

    environment {
        HELM_HOME = "${env.WORKSPACE}/.helm"
        KUBECONFIG = "${env.WORKSPACE}/.kube/config"
        CHART_PATH = "helm-chart/."
        RELEASE_NAME = "phonebook"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ercansayici/b2metric-task.git'
            }
        }

        stage("Login Docker") {
            steps {
                  script {
                    sh "docker login --username=ercandevops --password=xxxxxxx"
                }
            }
        }

        stage('Install Helm and kubectl') {
            steps {
                sh '''
                if ! [ -x "$(command -v helm)" ]; then
                  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
                fi
                
                if ! [ -x "$(command -v kubectl)" ]; then
                  curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
                  chmod +x ./kubectl
                  sudo mv ./kubectl /usr/local/bin/kubectl
                fi
                '''
            }
        }

        stage('Setup Kubernetes Config') {
            steps {

                withCredentials([file(credentialsId: 'kubeconfig-minikube', variable: 'KUBECONFIG_FILE')]) {
                    sh 'mkdir -p ~/.kube'
                    sh 'cp $KUBECONFIG_FILE ~/.kube/config'
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {

                sh '''
                helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} -f ~/helm-chart/values.yaml
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
