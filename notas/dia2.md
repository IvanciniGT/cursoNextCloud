Crear un contenedor de nginx
Pero ese contenedor lo queremos con nuestro propio fichero de configuración de nginx.
El fichero que venga de configuración lo quiero editar.

/etc/nginx/nginx.conf     RUTA DENTRO DEL CONTENEDOR

Extraer archivos de un contenedor. CASOS DE USO:
- Extraer un archivo de configuración por defecto
- Extraer logs
- En ocasiones creamos un contenedor y no hemos inyectado volumenes adecuadamente. 
    Extraigo una ruta y recreo el contenedor ya con un volumen

----
Qué características tiene un entorno de producción que no tienen el resto de entornos (desarrollo, preproducción):
- Alta disponibilidad: Conseguir un determinado % tiempo de servicio y recuperación rápida en caso de caida
- Escalabilidad:  Necesito que mi entorno de producción sea capaz de ajustarse a la demanda presente en un momento dado

Cómo conseguimos estas características en un entorno:
Cluster: Conjunto de recursos ofreciendo todos el mismo servicio
    - De forma simultanea: Activo-Activo    Alta disponibilidad   - Escalabilidad
    - No:                  Activo-Pasivo    Alta disponibilidad   - NO escalabilidad

| Disponibilidad de mi sistema del 99%        100 dias 1 puede no funcionar... 3.5 dias al año parado       
|                                  99,9%      1000 dias 1 abajo .... 8 horas al año caido
V                                  99,99%     minutos
€€€€€€€€€€€

AppX           cpus
    server1    25%
    server2    25%
    server3    25%
    server4    25%

Necesito escalar en este escenario? SI
Si uno cae, el otro no es capaz de asumir toda la carga de trabajo


App X
    server1    <
    server2    <    Balanceador de carga (HAProxy, nginx, F5, httpd)



Orquestador.

Volumen de peticiones:
    Entorno de producción
    Entorno de desarrollo

Aplicación de gestión de emergencias. Un día X a lo mejor no recibo más de 10 peticiones
Y tengo al equipo de desarrollo trabajando en ella y hacen cientos de pruebas mientras desarrollan

Picos de uso. Recursos
AppX     día 1      10 usuarios
AppX     día 10     200 usuarios
AppX     día 11     300 usuarios
AppX     día 12     200 usuarios
AppX     día 100    2000 usuarios
AppX     día 1000   5000 usuarios


INTERNET
AppY     día n      10 peticiones
AppY     día n+1    100000 peticiones           Black friday       PC Componentes: x8 infra
AppY     día n+2    100 peticiones
AppY     día n+3    300000 peticiones           CiberMonday


Cómo encaja esto con los contenedores?
Precisamente si hay un sitio donde los contenedores se han impuesto es en los entornos de producción.

Es más fácil es añadir/eliminar nuevos elementos a un cluster
Es más eficiente.

Por qué?
Crear un contenedor es una operación rápida y sencilla
Rápida: porque realmente lo único que viene ocurriendo es que estamos creando poco más que una carpeta a nivel del FS
        La chica, quien la trae? La imagen, que ya puede estar predescargada
Al replicar un contenedor (generar uno nuevo, habiendo borrado otro o no) los datos gordos, la imagen, se reutilzia.
    Optimización del almacenamiento
    Optimización del tiempo. No hay que reinstalar, descargar, copiar nada

Me da igual lo que tenga esa imagen de contenedor o los contenedores que montemos
Siempre lo hago con los mismos comandos.

El trabajar con contenedores implica una serie de cambios a nivel conceptual.


Maquina física o no. Recursos. App -> Límite de recursos le imponía a la app. La máquina solía estar dedicada a la app.

Montar unidades de ejecución (Contenedores) de un tamaño no muy grande, limitados - Medidos:
    1 contenedor: 2 Gb RAM + 2 cpus       <      200 usuarios
    
    1,2, 17 contenedores. Dónde... En una máquina o en 17

A día de hoy de donde se sacan los recursos de HW de producción: Clouds
OpenStack < Cloud privado

La tendencia del mercado, de la industria: Si la gente va apor aquí, ahí es donde se está desarrollando trabajo.

AUTOMATIZAR: Estandarización de los procedimientos de trabajo



50 apps que trabajan por http:
    https < claves publícas + privadas y certificados
            Esos certificados son eternos? no... caducan
                Si los genero yo, (autofirmados) < CA. Quién la reconoce? nadie la da valor.
                
    
                
                                                                    DNS  (https) tls 1.2
   Certificados para cada server emitidos por una CA propia: 70-80 certif
App1
    server1                     BC1       <>            Proxy-reverso      >         Mundo    emergencias.gc.es = IP: 8.10.10.10
    server2                       Certificado CA propia           Certificado (CA reconocida mundialmente) - 50 certificados
App2
    server1                     BC2
App3
    server1                     BC3
    server2
    server3
App4

App50


150, 170 certificados, que:
Hay que generar
Mantener
Configurar
La carga de trabajo de esto es grande
ISTIO, LinkerD < 5 minutos


Hoy en día no hablamos tanto de aplicaciones como de sistemas
    Servicios y Microservicios

No quiero montar una app monolitica
Servicios que conjuntamente ofrecen una funcionalidad > Sistemas

Banco: 
Servicio de consulta de saldo  < Programa que está instalado en un cajero automatico
                                 Programa que usan los empleados en ventanilla
                                 Programa que contesta llamadas de telefono
                                 Programa que usan las personas desde la app telefono
                                 Programa que usan las personas desde la app web
                                 



NextCloud GUAY !

Contenedor NextCloud 
    - 1 contenedor?                             Varios                              Activo-Activo
        1 máquina HW o en varias?               Varias 
    - 1 balanceador de carga                    Instalarlo y configurarlo           Activo-Pasivo   GRATIS
                                                                                                    No tienes un nginx
                                                                                                    BALANCEO DE CARGA NetFilter kernel linux
Contenedor BBDD :
    - MariaDB ****        
        Cuantos contenedores? 1                 Varios 
    - MySQL
    - PostgreSQL
    Si tengo varios contenedores:
        Balanceo de carga                           Lo instalé Nacho ... o que me lo instale/configure una herramienta como 
                                                    Swarm o kubernetes

Contenedor Keycloud: Identidades
    - Cuantos contenedores:                     1 activo y otro pasivo

Contenedor postgreSQL                           1 activo

RocketChat                                      1 contenedor activo

----
Jitsi       - 1 contenedor?


----------------------------------------------------------------------------------------------------
    
Los 2 contenedores de Nextcloud son iguales entre si > 1 volumen de datos compartido entre los 17 nextcloud
Los contenedores de MariaDB son diferentes entre si  > Cada instancia de BBDD que yo levante necesita su propio volumen de almacenamiento
    MariaDB:
        Standalone: 1 nodo - 1 contenedor
        Replicación: 2 nodos - 2 contenedores, uno es primario y otro secudario
        MariaDB Galera: n nodos - cluster activo-activo
        
Un cluster activo-pasivo en contenedores es un concepto especial... 
    porque lo que hacemos es tengo solo 1 activo... y si se cae, no es que levante un pasivo
                                                    es que lo creo de cero y lo levanto
                                                    NO ESTA PRECREADO
    Donde tengo que tener cuidado?   IP + fqdn(que se mantenga actualizado DNS) docker, swarm, kubernetes
    
    
REAL:
2 máquinas: 
    
    kubernetes
    docker
menos recursos que tenerlas sobre el hierro
    


1 máquina  física
    
    1 mv NextCloud
        8 cpus
        32 gbs de ram
            5 Tbs
    1 mv jitsy
        4 cpus
        8 Gbs RAM
            60 Gbs almacenamiento
    1 mv < Jitsy
    1 mv Nextcloud < Nexcloud

Alta disponibilidad
    


----------------------------------------------------------------------------------------------------------------------------------
1 instalacion de nextcloud en docker-compose
2 Kubernetes                                                <<< 10 minutos


---------------------
Docker-compose:
Como un cliente de dockerd


--------------------
docker:
    dockerd
    docker           cliente ---> dockerd
docker-compose  otro cliente ---> dockerd

Como hablo yo con docker, a través de linea de comandos
Como hablo yo con docker-compose, a traves de ficheros YAML
    Ventajas de docker-compose:
        En un fichero YAML incluyo información de múltiples cosas
    Docker-compose también es un cliente de docker-swarm
    
--------------------------------------------------------------
Cluster
    Nodo1
        dockerd  ---|
    Nodo2            > cluster: Los opero de forma única (swarm, KUBERNETES)
        dockerd  ---|
        
Digo lo que quiero tener en el cluster... no me pongo a hacer operaciones en cada máquina

Comparado con Kubernetes swarm ofrece mucha menos funcionalidad... y nadie está montando cosas sobre SWARM
----------------------
YAML


docker-compose:
    up:     crear contenedores o actualuizarlos, y levantar esos contenedores (start) + attach
    down:   para contenedores y los borra
    stop:   parar contenedores
    start:  arranca contenedores
    restart: reinicia contenedores




1 mv NextCloud
    8 cpus
    32 gbs de ram
        30 Gbs
1 mv jitsy
    4 cpus
    8 Gbs RAM
        60 Gbs almacenamiento
1 mv NextCloud2
    8 cpus
    32 gbs de ram
        30 Gbs

NFS
iscsi
fibrechannel
    5 Tbs



alpine en imagenes de contenedores
ubuntu
fedora


Que viene en esas imagenes:
    /bin/
        cp
        mkdir
        sh
        touch
        cat
        
ubuntu: +
    apt
    apt-get

fedora: +
    yum
    
alpine:
    no bash
    ash





imagen de contenedor: Que viene?
    XXX.apache      <  apache + modulo apache php + php + nextcloud
    XXX.fpm         <  fpm (fastCGI) - php + nextcloud

montar yo mi propia imagen de contenedor, llamada:
    XXX.nginx       < XXX.fpm + nginx
    command:            fpm-php  ESTE YA NO... que es el que viene por defecto en la imagen: fpm
                        nginx -g daemon off;
    Para este trabajo montariamos un fichero Dockerfile
    Directamente puedo pedir a docker-compose que un contenedor lo quiero con una imagen, no de las standar
        Sino que se genere automaticamente basada en mi dockerfile
        
        
    Sobre la imagen base de nextcloud:
        apt update
        apt install nginx -y
                        
    
    