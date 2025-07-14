pipeline {
    agent {
        docker {
            image 'dasigr/cypress-quickstart'
        }
    }

    environment {
        IMAGE_NAME = 'dasigr/cypress-quickstart'
        REGISTRY_CREDENTIALS = 'docker-hub'

        // Use local workspace for Cypress cache
        CYPRESS_CACHE_FOLDER = "${WORKSPACE}/.cache/Cypress"
        NODE_ENV = 'test'
        NO_COLOR = 'true'
    }

    options {
        // Keep only the latest 5 builds to avoid space issues
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.IMAGE_TAG = "${shortCommit}"
                    // sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Restore Cypress Cache') {
            steps {
                script {
                    // Restore Cypress cache if previously archived
                    if (fileExists("${WORKSPACE}/cypress-cache.tar.gz")) {
                        sh """
                            mkdir -p ~/.cache
                            tar -xzf cypress-cache.tar.gz -C ~/.cache
                        """
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
                sh 'npx cypress install' // Ensures binary is present
                sh 'npm run cy:verify'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm run cy:run'
            }
        }

        // stage('Save Cypress Cache') {
        //     steps {
        //         script {
        //             sh """
        //                 mkdir -p ~/.cache
        //                 tar -czf cypress-cache.tar.gz -C ~/.cache Cypress
        //             """
        //             archiveArtifacts artifacts: 'cypress-cache.tar.gz', fingerprint: true
        //         }
        //     }
        // }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'cypress/videos/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'cypress/screenshots/**/*', allowEmptyArchive: true
            }
        }

        // stage('Login to Docker Registry') {
        //     steps {
        //         script {
        //             docker.withRegistry('https://index.docker.io/v1/', REGISTRY_CREDENTIALS) {
        //                 echo 'Logged in to Docker Hub'
        //             }
        //         }
        //     }
        // }

        // stage('Push Docker Image') {
        //     steps {
        //         script {
        //             docker.withRegistry('https://index.docker.io/v1/', REGISTRY_CREDENTIALS) {
        //                 sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        //             }
        //         }
        //     }
        // }
    }

    post {
        success {
            echo "Image pushed: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            emailext (
                to: 'contact@a5project.com',
                subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed. Check console: ${env.BUILD_URL}"
            )
        }
    }
}