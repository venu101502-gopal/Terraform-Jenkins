pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically apply after plan?')
        booleanParam(name: 'autoDestroy', defaultValue: false, description: 'Automatically destroy after apply?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                dir("terraform") {
                    git "https://github.com/yeshwanthlm/Terraform-Jenkins.git"
                }
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                dir("terraform") {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval Before Apply') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def planContent = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the Terraform plan?",
                        parameters: [
                            text(name: 'Plan', defaultValue: planContent, description: 'Review the plan before applying')
                        ]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("terraform") {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }

        stage('Destroy Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoDestroy
                }
            }
            steps {
                input message: "Do you want to destroy the infrastructure?"
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.autoDestroy }
            }
            steps {
                dir("terraform") {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
