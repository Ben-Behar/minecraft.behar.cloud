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
VOLUME ["/app/world","/app/io","/app/config/"]
EXPOSE 25565
RUN ln -s /app/config/whitelist.json /app/whitelist.json
RUN ln -s /app/config/server.properties /app/server.properties
CMD ["/app/launcher", "java", "-Xms1G", "-Xmx4G", "-Dfml.readTimeout=120", "-jar", "/app/forge-1.12.2-14.23.5.2768-universal.jar", "nogui"]
# vanilla # docker run -dp 25565:25565 -v minecraft.behar.cloud-deleteme:/app/world  -v minecraft.behar.cloud-io:/app/io --name minecraft.behar.cloud docks.behar.cloud/minecraft.behar.cloud:beru
# docker run -d -p 25565:25565 -v minecraft.behar.cloud-world:/app/world -v minecraft.behar.cloud-mods:/app/mods -v minecraft.behar.cloud-io:/app/io --name minecraft.behar.cloud docks.behar.cloud/minecraft.behar.cloud:beru
