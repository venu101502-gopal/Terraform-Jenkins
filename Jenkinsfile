pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'autoDestroy', defaultValue: false, description: 'Automatically destroy infrastructure after apply?')
    }

    // Ensures parameters show up in the Jenkins UI
    triggers { none() }

    stages {
        stage('Initialize') {
            steps {
                script {
                    properties([
                        parameters([
                            booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?'),
                            booleanParam(name: 'autoDestroy', defaultValue: false, description: 'Automatically destroy infrastructure after apply?')
                        ])
                    ])
                }
            }
        }

        // Continue with Checkout, Plan, etc.
