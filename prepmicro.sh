#! /bin/bash

################################################
# Prepare "nolike"
################################################

ECR_Mono=`aws ecr describe-repositories | grep "repositoryUri.*mono" | \
tr -s " " | cut -f3 -d" " | sed 's/[",]//g'`
export ECR_Mono
cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app
cp -r monolith-service nolike-service
sed -i -e 's/^# @app.route/@app.route/' \
	-e 's/^# def fulfillLikeMysfit/def fulfillLikeMysfit/' \
	-e 's/^#     serviceResponse/    serviceResponse/' \
	-e 's/^#     flaskResponse/    flaskResponse/' \
	-e 's/^#     return flaskResponse/    return flaskResponse/' \
	nolike-service/service/mythicalMysfitsService.py
cd nolike-service/
docker build -t monolith-service:nolike .
docker tag monolith-service:nolike ${ECR_Mono}:nolike
docker push ${ECR_Mono}:nolike
#################################
# Prepare "like" service"
#################################
ECR_Like=`aws ecr describe-repositories | grep "repositoryUri.*like" | \
tr -s " " | cut -f3 -d" " | sed 's/[",]//g'`
export ECR_Like
cd ~/environment/amazon-ecs-mythicalmysfits-workshop/workshop-1/app/like-service
docker build -t like-service .
docker tag like-service:latest ${ECR_Like}:latest
docker push ${ECR_Like}:latest


