FROM jenkins/jenkins:lts

LABEL Maintainer="Luan Tran <minhluantran017@gmail.com>"
LABEL Description="Jenkins master with pre-configurations"

ARG CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs
ARG CASC_PATH=./jenkins/casc_configs

COPY ${CASC_PATH} ${CASC_JENKINS_CONFIG}
COPY ./jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt