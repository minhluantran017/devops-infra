FROM ubuntu:18.04

LABEL Maintainer="Luan Tran <minhluantran017@gmail.com>"
LABEL Description="Ubuntu base image for Jenkins slave"

RUN apt update && apt install -y openjdk-8-jdk
WORKDIR /mnt/jenkins