// install
yum intall -y docker
// start docker
systemctl start docker
// enable docker to start on boot
systemctl enable docker
// check docker status
systemctl status docker
// check docker version
docker --version
// run hello world container
docker run hello-world
// docker images
docker images
// docker ps
docker ps
// list all containers
docker ps -a
// stop a container
docker stop <container_id>
// run a container
docker run -it --name my_container nginx
// remove a container
docker rm <container_id>
// remove an image
docker rmi <image_id>

// login to the container
docker exec -it my_container bash or docker attach my_container
// to exit from container
exit
// stop the container
docker stop my_container
// remove the container
docker rm my_container
// kill the container
docker kill my_container
// to posw the container
docker pause my_container
// to unpause the container
docker unpause my_container
// restrt the container
docker restart my_container
// docker inspect to see details of container
docker inspect my_container
// top
docker top my_container
// stats
docker stats my_container
// to see logs of container

docker logs my_container
// to see resource usage of container
docker stats my_container
// to see network information of container
docker network inspect my_container
// to see port mapping of container
docker port my_container
// to see environment variables of container
docker exec my_container env
// to see processes running in container
docker exec my_container ps aux
// to copy file from host to container
docker cp /path/to/local/file my_container:/path/to/container/file
// to copy file from container to host
docker cp my_container:/path/to/container/file /path/to/local/file

// save the image in tar file
docker save -o my_image.tar my_image
// and share the tar file to other system and load the image
docker load -i my_image.tar
// to delete unused images
docker image prune -a
// container to images
docker commit my_container my_image:latest
// to see all images
docker images

docker ps -aq
// and kill
docker kill $(docker ps -aq)
// and remove
docker rm $(docker ps -aq)

// foe images
docker images -q
// and remove
docker rmi $(docker images -q)  
// stop all conatiner
docker stop $(docker ps -aq)

// dockefile components
FROM : used to get bases images
RUN: used to run linux command (DUring image creation)
CMD: used to run linux command (After container creation)
ENTRYPOINT: high periorty than cmd
COPY: to copy local file to container
ADD: to copy internet file to container
WORKDIR : to open req directry
LABEL: to add label for docker images
ENV: to set envirnmonet varibale (inside container)
ARGS: to pass env variable (outside container)
EXPOSE: to give port number


// for DockerFile write
FROM ubuntu:latest
RUN apt-get update && apt-get install -y nginx
RUN echo "Hello World" > /var/www/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

// run docker file
docker build -t my_nginx_image:v1 .
// with this image create container
docker run -it --name cont1 my_nginx_image:v1

// second Dockerfile
FROM ubuntu:latest 
RUN apt-get update && apt-get install -y nginx git tree
RUN touch file1
RUN apt install python3 -y
CMD apt install mysql-server -y // during container creation mysql server will be installed