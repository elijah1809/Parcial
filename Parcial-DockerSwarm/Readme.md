# Docker Swarm  
Creación de 3 nodos en virtualbox por medio de vagrant y por medio de esto obtener un Dock Swarm

![ezgif-1-66e3c945a9](https://cloud.githubusercontent.com/assets/8946358/23815796/b0fb5c62-060f-11e7-8375-c7352eb327b6.gif)  

> **watch whole demo [here](https://vimeo.com/207867476)**

## Instalación
Instalación de Vagrant [here](https://www.vagrantup.com/downloads.html)  

Clonar este repositorio 
```  
git clone https://github.com/elijah1809/Parcial.git

```

## Iniciar el levantamiento de VMs  
Ejecutar `vagrant up`  
  - Este levantará 3 VMs - **manager**, **worker-1** & **worker-2** todas provisionadas con Docker
  - [monicagangwar/docker-swarm-vagrant](https://hub.docker.com/r/monicagangwar/docker-swarm-vagrant/) 
   Este corre en el puerto `docker run -p 8000:8000 --name network_parcial monicagangwar/docker-swarm-vagrant`  

Se puede ingresar al Manager con este comando `vagrant ssh manager`  
Para ingresar a los otros nodos con el comando `vagrant ssh worker-1` o `vagrant ssh worker-2`  

## Comando para escalación en los contenedores las replicas de servicios que se necesitan montar, se va distribuir en diferentes nodos de forma equitativa o balanceada, donde todos aquellos workers pertenezcan al Docker Swarm van a funcionar como un balanceador de carga.

docker service update --replicas 10  network_parcial

## Listado de commandos de Docker  
- `docker service ls`  
   Lists the services created
- `docker network ls`  
   Lists the networks created and available by default  
- `docker node ls`  
   Lists all the nodes in swarm
- `docker service ps <service-name>`  
   Lists all the containers running in all swarm nodes.
