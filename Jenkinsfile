pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Creating lambda_function.zip'
                sh '''
                zip lambda_function.zip lambda_function.py
                '''
            }
        }
        stage('TF Init') {
            steps {
                echo 'Executing Terraform Init'
                sh 'terraform init -reconfigure'
            }
        }
        stage('TF Validate') {
            steps {
                echo 'Validating Terraform Code'
                sh 'terraform validate'
            }
        }
        stage('TF Plan') {
            steps {
                echo 'Executing Terraform Plan'
                sh 'terraform plan'
            }
        }
        stage('TF Apply') {
            steps {
                echo 'Executing Terraform Apply'
                sh 'terraform apply -auto-approve || exit 1'
            }
        }
        stage('Invoke Lambda') {
            steps {
                script {
                    // Ensure the Apply stage was successful before invoking Lambda
                    if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
                        echo 'Invoking your AWS Lambda'
                        sh '''
                        aws lambda invoke --function-name InvokeLambda_Teju2707 --log-type Tail --query "LogResult" --output text lambda_output.log | base64 -d
                        '''
                    } else {
                        echo 'Skipping Lambda invocation due to earlier failure(s)'
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up workspace'
            deleteDir()
        }
        success {
            echo 'Pipeline succeeded'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
