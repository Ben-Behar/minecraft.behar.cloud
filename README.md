# minecraft.behar.cloud
The Docker image to setup my minecraft server

Usage:
 $ docker build .
 $ docker run -itp 25565:25565 -v minecraft.world:/home/minecraft/volume


Backup Volume:
 $ docker run --rm -v $(VOLUME):/data -v $(pwd):/backup busybox tar cvf /backup/backup.tar /data
