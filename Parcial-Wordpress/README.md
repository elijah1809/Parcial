# Crear un sitio Wordpress usando DigialOcean para la infraestructura, utilizando Terraform y Ansible 
Este ayudara a crear 2 droplets, una VPC para comunicación interna y un balanceador de carga

### Como usar este respositoio

### Clonar este repositorio 

```

git clone https://github.com/elijah1809/Parcial.git

```

Debes tener la ultima versión de Terraform

Terraform v1.2.1
+ provider.digitalocean v1.3.0

### Digital Ocean Token

Es necesario tener una cuenta de DigitalOcean creada para poder montar esta infraestructura.

Para genertar el token puedes seguir este Runbook: https://cloud.digitalocean.com/account/api/tokens


### Crear el archivo de variables terraform.tfvars

Debes crear este archivo en la raiz de tu proyecto

do_token = "" #### Este debe ser el token generado en Digital Ocean

ssh_key_private1 = "" Esta es la clave ssh privada generada en tu computadora. https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/create-with-openssh/
droplet_ssh_key_id1 = "" para sacar este ID debe ser por medio del siguiente comando "doctl compute ssh-key list"
droplet_name1 = "" Debe ser el nombre del droplet no. 1
droplet_size1 = "" Debe ser el tamaño del droplet no. 1 
droplet_region1 = "" Debe ser la region del droplet no. 1

ssh_key_private2 = "" Esta es la clave ssh privada generada en tu computadora. https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/create-with-openssh/
droplet_ssh_key_id2 = "" para sacar este ID debe ser por medio del siguiente comando "doctl compute ssh-key list"
droplet_name2 = "" Debe ser el nombre del droplet no. 2
droplet_size2 = "" Debe ser el tamaño del droplet no. 2 
droplet_region2 = "" Debe ser la region del droplet no. 2

```

Estos comando pueden ser de ayuda para la conexión de tu computadora a DigitalOcean 

To obtain the values of the region, the ssh key, the name of the image and the size of the virtual machine, installed the Digital Ocean command-line client.


To list all available ssh keys in the account:
```

$ doctl  -t [TOKEN] compute ssh-key list
```


To list all OS available:
```

$ doctl  -t [TOKEN] compute  image list --public
```


To list all OS available:
```

$ doctl  -t [TOKEN] compute  region list
```


To list all sizes available:
```

$ doctl  -t [TOKEN] compute  size list
```


**terraform.tfvars**
```
#### Este es un ejemplo de como pudieron haber quedado los valores de las variables

do_token = "123bc07c22f942ceccbdc010ff18025db0199bd6f916953c90b974d95caa7439"
ssh_key_private = "~/.ssh/id_rsa"
droplet_ssh_key_id = "2632045"
droplet_name = "MyBlog"
droplet_size = "s-1vcpu-1gb"
droplet_region = "nyc1"
```



Note: both the key path and the id of the digital ocean key must refer to the same key.

### Wordpress configuration (optional)
Although it is not necessary to execute the code, you can optionally change the values defined for the MySQL database to be used with wordpress as well as the configuration values of wordpress:

playbooks/roles/mysql/defaults/main.yml contains the following variables that can be modified:

```

---
# Estos son los datos por defecto para la configuración de la base de datos MYSQL
wp_mysql_db: wordpress
wp_mysql_user: wordpress
wp_mysql_password: randompassword
```

If these values are not modified, they will be the data that will be used to create the wordpress database in MySQL and will also be the values that will be used in the wp_config.php file while ansible configures the site.

playbooks/roles/wordpress/defaults/main.yml contains the following variables that can be modified:


```
---
# Esto son los datos por defecto para el sitio de Wordpress 
wp_site_title: New blog
wp_site_user: superadmin
wp_site_password: strongpasshere
wp_site_email: some_email@example.com
```


If these values are not modified, they will be the data you will need to enter Wordpress as an administrator user.

### Execute terraform


Para hacer el despliegue, se deben correr estos comando de Terraform
```

$ terraform plan
$ terraform apply
```

## Resumen de las configuraciones


Este proceso hace (25) tareas para la creación de dos Droplets con Wordpress:

**Terraform**

Create Digitral Ocean droplet

**Ansible** ### Instala las siguients aplicaciones y servicios para levantar la aplicación de Wordpress

- Install python 2
- Update yum cache
- Download and install MySQL Community Repo
- Install MySQL Server
- Install remi repo
- Enable remi-php72
- Update yum
- Install Apache and PHP
- Install php extensions
- Start MySQL Server and enable it
- Remove Test database if it exists
- Remove All Anonymous User Accounts
- Create mysql database
- Create mysql user
- Download WordPress
- Extract WordPress
- Update default Apache site
- Update default document root
- Copy sample config file
- Update WordPress config file
- Download wp-cli
- Test if wp-cli is correctly installed
- Finish wordpress setup via wp-cli
- Restart apache