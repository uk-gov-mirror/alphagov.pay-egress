#!/usr/bin/env groovy

pipeline {
  agent any

  options {
    ansiColor('xterm')
    timestamps()
  }

  libraries {
    lib("pay-jenkins-library@master")
  }

  stages {
    stage('Docker Build') {
      steps {
        script {
          buildAppWithMetrics{
            app = "egress"
          }
        }
      }
      post {
        failure {
          postMetric("egress.docker-build.failure", 1)
        }
      }
    }

    stage('Docker Tag') {
      steps {
        script {
          dockerTagWithMetrics {
            app = "egress"
          }
        }
      }
      post {
        failure {
          postMetric("egress.docker-tag.failure", 1)
        }
      }
    }
    stage('Deploy') {
      when {
        branch 'master'
      }
      steps {
        deployEcs("egress")
      }
    }
    stage('Complete') {
      failFast true
      parallel {
        stage('Tag Build') {
          when {
            branch 'master'
          }
          steps {
            tagDeployment("egress")
          }
        }
        stage('Trigger Deploy Notification') {
          when {
            branch 'master'
          }
          steps {
            triggerGraphiteDeployEvent("egress")
          }
        }
      }
    }
  }
  post {
    failure {
      postMetric(appendBranchSuffix("egress") + ".failure", 1)
    }
    success {
      postSuccessfulMetrics(appendBranchSuffix("egress"))
    }
  }
}
