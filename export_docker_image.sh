#! /bin/bash
docker build -t ben-behar/minecraft.ben.behar.cloud:v1 .
printf "Saving image as minecraft.image.tar..."
docker save ben-behar/minecraft.ben.behar.cloud > minecraft.image.tar
printf "DONE!\n"
