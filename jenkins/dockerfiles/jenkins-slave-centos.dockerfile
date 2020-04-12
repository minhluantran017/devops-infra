FROM centos:7

LABEL Maintainer="Luan Tran <minhluantran017@gmail.com>"
LABEL Description="Centos base image for Jenkins slave"

RUN yum update -y && yum install java-1.8.0-openjdk-devel -y
WORKDIR /mnt/jenkins