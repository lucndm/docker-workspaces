IMAGE_NAME=minhluc/docker-workspaces
IMAGE_BY_DATE=$IMAGE_NAME:$(date +"%Y%m%d")
docker build -t $IMAGE_NAME:latest .
docker push $IMAGE_NAME:latest
docker tag $IMAGE_NAME:latest $IMAGE_BY_DATE
docker push $IMAGE_BY_DATE
