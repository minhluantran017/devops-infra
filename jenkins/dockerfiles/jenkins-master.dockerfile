FROM jenkins/jenkins:lts

LABEL Maintainer="Luan Tran <minhluantran017@gmail.com>"
LABEL Description="Jenkins master with pre-configurations"

ARG CASC_JENKINS_CONFIG=/var/jenkins_home/jcasc
ARG CASC_PATH=./jenkins/jcasc

COPY ${CASC_PATH} ${CASC_JENKINS_CONFIG}
COPY ./jenkins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt