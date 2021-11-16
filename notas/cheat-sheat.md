docker TIPO_OBJETO VERBO <ARGS>

TIPO DE OBJETO:
    container
    image
    volume
    network
    ...
    
VERBOS:
    create
    rm
    list
        start   container
        pull    image
        
        
Listar contenedores:                                    Alias:
    docker container list                               docker ps
    docker container list --all                         docker ps --all

Listar imagenes:
    docker image list                                   docker images
                        -q      muestra solo los identificadores de las imagenes

Borrar un contenedor
    docker container rm NOMBRE                          docker rm NOMBRE
                                -f (En modo forzado... aunque el contenedor este en ejecución)

Descargar una imagen
    docker image pull IMAGEN                            docker pull IMAGEN

Borra imagenes: 
    docker image rm ID_IMAGEN                           docker rmi ID_IMAGEN

Crear un contendor
    docker container create <ARGS> imagen_base
                            --name MINOMBRE
                            -e
                            -v
                            -p

Arrancar un contenedor:
    docker container start MINOMBRE                     docker start MINOMBRE

Ejecutar procesos dentro de un contenedor:
    docker exec <ARGS> CONTENEDOR COMANDO

Detalle del contenedor:
    docker container inspect CONTENEDOR                 docker inspect CONTENEDOR


docker run: OLVIDAOS DE QUE EXISTE... Su caso de uso es muy muy muy restringido


Docker logs: Ver los logs del contenedor....
    Qué son los logs del contenedor?
    Los logs de un contenedor son el stdout y el stderr del proceso 1 que corre en el contenedor
    
Extraer archivos de un contenedor
    docker cp mi-nginx:/etc/nginx/nginx.conf ./environment/datos/nginx/nginx.conf

Inyectar archivos a un contenedor
    docker cp  ./environment/datos/nginx/nginx.conf mi-nginx:/etc/nginx/nginx.conf   # RARO. ESTO NO SE HACE