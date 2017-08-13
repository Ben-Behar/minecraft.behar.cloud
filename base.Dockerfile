# Ubuntu 15.04 w/ Java 8
# $ docker build -t ben-behar/minecraft.ben.behar.cloud:v1

FROM ubuntu:15.04
MAINTAINER Ben Behar, https://github.com/ben-behar
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean
WORKDIR /home/minecraft
COPY forge-*-installer.jar forge-installer.jar
RUN java -jar forge-installer.jar --installServer
