docker pull nginx:latest
docker container create --name=mi-nginx -v /home/ubuntu/environment/datos/nginx/nginx.conf:/etc/nginx/nginx.conf nginx:latest