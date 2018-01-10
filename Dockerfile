FROM alpine:3.3
RUN apk add openjdk8-jre-base --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
  && apk update \
  && apk add gcc musl-dev \
  && rm -rf /var/cache/apk/*
WORKDIR /app
COPY forge-*-installer.jar forge-installer.jar
RUN java -jar forge-installer.jar --installServer
COPY server .
COPY launcher.c .
RUN gcc -o launcher launcher.c
VOLUME ["/app/world", "/app/io"]
EXPOSE 25565
CMD ["/app/launcher", "java", "-Xms1G", "-Xmx1G", "-jar", "/app/forge-1.12-14.21.1.2443-universal.jar", "nogui"]
