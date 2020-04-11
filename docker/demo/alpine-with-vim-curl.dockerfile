FROM alpine:latest
RUN apk update
RUN apk add vim
RUN apk add curl