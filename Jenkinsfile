pipeline {
    agent any

    environment {
        // Define any environment variables here if necessary
    }

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
                echo 'Validating Terraform configuration'
                sh 'terraform validate'
            }
        }
        stage('TF Plan') {
            steps {
                echo 'Generating Terraform Plan'
                sh 'terraform plan'
            }
        }
        stage('TF Apply') {
            steps {
                echo 'Applying Terraform configuration'
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Invoke Lambda') {
            steps {
                echo 'Invoking Lambda function'
                // Add steps to invoke the Lambda function here
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
