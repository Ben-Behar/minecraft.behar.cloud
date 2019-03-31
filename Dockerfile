# docker build . -t docks.behar.cloud/minecraft.behar.cloud:beru
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
CMD ["/app/launcher", "java", "-Xms1G", "-Xmx4G", "-jar", "/app/forge-1.12.2-14.23.5.2768-universal.jar", "nogui"]
# docker run -itp 25565:25565 -v minecraft.behar.cloud-world:/app/world -v minecraft.behar.cloud-mods:/app/mods -v minecraft.behar.cloud-io:/app/io --name minecraft.behar.cloud docks.behar.cloud/minecraft.behar.cloud:beru
