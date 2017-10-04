FROM alpine:3.3
RUN apk add openjdk8-jre-base --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
    && rm -rf /var/cache/apk/*
WORKDIR /home/minecraft
COPY forge-*-installer.jar forge-installer.jar
RUN java -jar forge-installer.jar --installServer
COPY server .
EXPOSE 25565
CMD ["java", "-Xms1G", "-Xmx1G", "-jar", "/home/minecraft/forge-1.12-14.21.1.2443-universal.jar", "nogui"]
