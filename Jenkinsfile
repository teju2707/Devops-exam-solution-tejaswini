pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
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
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Invoke Lambda') {
            steps {
                echo 'Invoking your AWS Lambda'
                sh '''
                aws lambda invoke --function-name InvokeLambda --log-type Tail --query "LogResult" --output text lambda_output.log | base64 -d
                '''
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
