pipeline {
    agent any

    tools {
        jdk 'JDK'       // Assurez-vous que "JDK" est configuré dans Manage Jenkins → Global Tool Configuration
        maven 'MAVEN'   // Assurez-vous que "MAVEN" est configuré dans Manage Jenkins → Global Tool Configuration
    }

    environment {
        GIT_CREDENTIALS = 'riani-yassine'
        DOCKER_HUB_CREDENTIALS = 'DOCKER_HUB_CREDENTIALS'
        DOCKER_IMAGE = 'yassineriani/student-management:latest'
        KUBE_CONFIG_CREDENTIALS = 'KUBE_CONFIG' // Jenkins credential contenant kubeconfig
    }

    stages {

        stage('Cloner le projet') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/riani-yassine/Devops-student.git',
                    credentialsId: "${GIT_CREDENTIALS}"
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Livrable prêt') {
            steps {
                echo 'Le build est terminé, le jar est prêt dans target/'
                sh 'ls -lh target/'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Déploiement Kubernetes') {
            steps {
                script {
                    // Récupération du kubeconfig depuis Jenkins credentials
                    withCredentials([file(credentialsId: "${KUBE_CONFIG_CREDENTIALS}", variable: 'KUBECONFIG_FILE')]) {
                        sh 'mkdir -p $HOME/.kube'
                        sh 'cp $KUBECONFIG_FILE $HOME/.kube/config'
                    }

                    // Déploiement MySQL
                    sh 'kubectl apply -f k8s/mysql-secret.yaml'
                    sh 'kubectl apply -f k8s/mysql-deployment.yaml'
                    sh 'kubectl apply -f k8s/mysql-service.yaml'

                    // Déploiement Spring Boot
                    sh 'kubectl apply -f k8s/springboot-deployment.yaml'
                    sh 'kubectl apply -f k8s/springboot-service.yaml'

                    // Vérification des pods et services
                    sh 'kubectl get pods -A'
                    sh 'kubectl get svc -A'
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
            sh 'mvn sonar:sonar'
                }
            }
        }   

    }
}