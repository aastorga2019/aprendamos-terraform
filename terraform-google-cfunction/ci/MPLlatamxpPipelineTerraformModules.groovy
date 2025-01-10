#!groovy
import com.latam.xp.devops.*

//@NonCPS
def call(body) {
    def MPL = MPLPipelineConfig(body)
    def UTILS = new com.latam.xp.devops.Utils()
    def FAILED_STAGE

    pipeline {
        agent {
            kubernetes {
                label "docker-${UUID.randomUUID().toString()}"
                defaultContainer 'terraform-gcloud-sdk'
                yaml """
                    apiVersion: v1
                    kind: Pod
                    spec:
                      serviceAccountName: default
                      hostAliases:
                      - ip: "127.0.0.1"
                        hostnames:
                        - "kubernetes"
                      containers:
                      - name: terraform-gcloud-sdk
                        image: gcr.io/latamxp-infrastructure/terraform-modules:5
                        imagePullPolicy: Always
                        command: [/bin/sh, -c, --]
                        args: [while true; do sleep 30; done;]
                """
            }
        }
        options { disableConcurrentBuilds() }
        environment {
            JENKINS_SLACK_CREDENTIALS = credentials('JENKINS_SLACK_CREDENTIALS')
            GITLAB_TOKEN = credentials('infra-tf-mods-gitlab-token')
        }
        stages {
            stage('Init, validation and format') {
                steps {
                    container("terraform-gcloud-sdk") {
                    script {
                        FAILED_STAGE=env.STAGE_NAME
                        sh """
                            echo "Inicializando"
                            terraform init
                            echo "Validando configuración"
                            git config --global --add safe.directory ${WORKSPACE}
                            pre-commit run -a
                        """
                    }
                }
            }
            }
            stage('Updating documentation') {
                when {
                  anyOf{
                    branch 'master'
                  }
                }
                steps {
                    script {
                        withCredentials([sshUserPrivateKey(credentialsId: 'jenkins-bitbucket', keyFileVariable: 'JENBITKEY')]){
                        FAILED_STAGE=env.STAGE_NAME
                        def TICKET_NUMBER = sh(script: 'git log -1 --pretty=format:%B | grep -oP "\\(\\K[^)]+" | head -n 1', returnStdout: true).trim()
                        def GIT_URL_SSH="ssh://git@coderepocsa.appslatam.com:7999" + "${GIT_URL.substring(GIT_URL.toLowerCase().indexOf('scm/') + 3)}"
                        def GITLAB_URL="https://gitlab.com/latamairlines" + "${GIT_URL.substring(GIT_URL.toLowerCase().indexOf('latamairlines/') + 13)}"
                        def USER = sh(script: 'git log -1 --pretty=format:%ae', returnStdout: true).trim()
                        sh """
                            if [ $USER != "cloudops.globant@latam.com" ]; then
                                git config --global user.email "cloudops.globant@latam.com"
                                git config --global user.name "Infra Pipeline"
                                git config --global --add safe.directory ${WORKSPACE}
                                if echo "$GIT_URL" | grep -q "coderepo"; then
                                    export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no -i $JENBITKEY"
                                    git remote set-url origin $GIT_URL_SSH
                                elif echo "$GIT_URL" | grep -q "gitlab"; then
                                    echo "machine gitlab.com" >> ~/.netrc && echo "login gitlab-ci-token" >> ~/.netrc && echo "password $GITLAB_TOKEN" >> ~/.netrc
                                    git remote set-url origin $GITLAB_URL
                                else
                                    echo "la url no es de bitbucket ni de gitlab"
                                fi
                                git checkout $BRANCH_NAME
                                git fetch --tags
                                mkdir old-readme
                                mv README.md ./old-readme
                                terraform-docs markdown table --output-file README.md --output-mode inject .
                                git-changelog -o CHANGELOG.md -c conventional --sections fix,feat,docs,chore,refactor,test,perf -b
                                ls -la CHANGELOG.md
                                echo "formateando changelog y readme"
                                pre-commit run -a > /dev/null 2>&1 || true
                                if ! diff -q ./README.md ./old-readme/README.md > /dev/null; then
                                    echo "There are changes in the README.md"
                                    git add README.md CHANGELOG.md
                                    git commit -m "docs: actualiza README.md y CHANGELOG.md ($TICKET_NUMBER)"
                                    git push origin $BRANCH_NAME
                                else
                                    echo "There are no changes in the README.md, only in CHANGELOG.md file"
                                    git add CHANGELOG.md
                                    git commit -m "docs: actualiza CHANGELOG.md ($TICKET_NUMBER)"
                                    git push origin $BRANCH_NAME
                                fi
                            else
                                echo "Este commit lo hizo jenkins."
                            fi
                            """
                        }
                    }
                }
            }
        }
        post {
            success {
                echo 'Completed successfully'
            }
            failure {
                echo 'Failed'
            }
        }
    }
}
