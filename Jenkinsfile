pipeline {
    agent {
        docker {
            image 'cypress/browsers:22.14.0'
        }
    }

    environment {
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

        stage('Build') {
            steps {
                sh 'docker image ls'
                sh 'docker build --platform linux/amd64 -t cypress-quickstart:latest .'
                sh 'docker image ls'

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
    }

    post {
        failure {
            emailext (
                to: 'contact@a5project.com',
                subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed. Check console: ${env.BUILD_URL}"
            )
        }
    }
}