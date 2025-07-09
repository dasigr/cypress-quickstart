pipeline {
    
    agent {
        docker {
            image 'node:22.14.0'
        }
    }
    
    stages {
        stage("Install Node packages") {
            steps {
                // Writes lock-file to cache based on the GIT_COMMIT hash
                writeFile file: "next-lock.cache", text: "$GIT_COMMIT"
         
                cache(caches: [
                    arbitraryFileCache(
                        path: "node_modules",
                        includes: "**/*",
                        cacheValidityDecidingFile: "package-lock.json"
                    )
                ]) {
                    sh "npm install"
                }
            }
        }
        
        stage("Build") {
            steps {
                // Writes lock-file to cache based on the GIT_COMMIT hash
                writeFile file: "next-lock.cache", text: "$GIT_COMMIT"
         
                cache(caches: [
                    arbitraryFileCache(
                        path: ".next/cache",
                        includes: "**/*",
                        cacheValidityDecidingFile: "next-lock.cache"
                    )
                ]) {
                    echo 'Building the application...'
                    // sh 'npm install --force'
                    // aka `next build`
                    sh "npm run build"
                }
            }
        }
        
        stage("Test") {
            steps {
                echo 'Testing the application...'
            }
        }
        
        stage("Deploy") {
            steps {
                echo 'Deploying the appliation...'
            }
        }
    }
}