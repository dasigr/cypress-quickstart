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
                sh 'npm ci --no-color'
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
    }
}