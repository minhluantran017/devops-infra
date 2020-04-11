job("Admin/seed-job") {
    label('master')
    description('Automatically create Jenkins job from DSL script or Jenkinsfile')
    parameters {
        stringParam('JOB_NAME', '', 'Job name to create')
        stringParam('GIT_REPO', 'ssh://git@github.com/minhluantran017/stuffs.git', 'Git repository to use')
        stringParam('GIT_BRANCH', 'master', 'Git branch to use')
        choiceParam('TYPE', ['JOB', 'PIPELINE'], 'Job type')
        stringParam('DSL_JENKINS_FILE', '', 'Groovy DSL script or Jenkinsfile path')
    }
    scm {
        git {
            remote {
                url('\${GIT_REPO}')
                branch('\${GIT_BRANCH}')
                credentials('github-devops-credential')
            }
	    extensions {
                cloneOptions {
                    timeout(2)
                    shallow(true)
                }
            }
        }
    }
    wrappers{
        timestamps()
        timeout {
            abortBuild()
            absolute(1000)
        }
    }
    steps {
        conditionalSteps {
            condition {
                stringsMatch('\${TYPE}', 'JOB', false)
            }
            runner('Fail')
            steps {
                dsl {
                    external('\${DSL_JENKINS_FILE}')
                }
            }
        }
        conditionalSteps {
            condition {
                stringsMatch('\${TYPE}', 'PIPELINE', false)
            }
            runner('Fail')
            steps {
                dsl {
                    text('''
pipelineJob("\${JOB_NAME}") {
    definition {
        cpsScm {
            lightweight(true)
            scm {
                git {
                    remote {
                        branch('\${GIT_BRANCH}')
                        credentials('github-devops-credential')
                        url('\${GIT_REPO}')
                    }
                }
            }
            scriptPath("\${DSL_JENKINS_FILE}")
        }
    }
}
''')
                }
            }
        }
    }
}
