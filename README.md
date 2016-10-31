#nginx-container 

[![Build Status](https://travis-ci.org/chouseknecht/nginx-container.svg?branch=master)](https://travis-ci.org/chouseknecht/nginx-container)

Adds an nginx service to your [Ansible Container](https://github.com/ansible/ansible-container) project. Run the following commands
to install the service:

```
# Set the working directory to your Ansible Container project root
$ cd myproject

# Install the service
$ ansible-container install chouseknecht.nginx-container
```
## Configuration 

A default configration file is placed at */etc/nginx/nginx.conf* with a simple virtual host definition listening for *http* requests on port *8000*. The best way to 
configure nginx with your own virtual hosts and defaults is by mounting a configuration file directly to */etc/nginx/nginx.conf*.  

### Logs

Logs are written to */var/log/nginx* with the individual files *access.log* and *error.log* linked to */dev/stdout* and */dev/stderr* respectively.

### Static content

Content is served from */var/www/nginx*. The default *index.html* from Nginx is copied into this directory. To serve your content, simply mount a host directory or named volume to this path.

## Requirements

- [Ansible Container](https://github.com/ansible/ansible-container)
- An existing Ansible Container project. To create a project, simply run the following:
    ```
    # Create an empty project directory
    $ mkdir myproject

    # Set the working directory to the new directory
    $ cd myproject

    # Initialize the project
    $ ansible-contiainer init
    ```

## Role Variables

nginx_default_port: 8000
> Sets the default http port for the server to listen on. *Note:* if you run the container as a non-privileged user, the default port value cannot be less than 1024.

nginx_default_server_name: '0.0.0.0'
> The server name that nginx will listen for.

nginx_package_name: nginx
> The Centos package name to install.

nginx_error_log: "/var/log/nginx/error.log warn"
> Set the error log file path and logging level. 

nginx_access_log: "/var/log/nginx/access.log"
> Set the access log file path and logging level. 

nginx_conf_file_path: /etc/nginx/nginx.conf
> The path to the default configuration file. 

nginx_mime_file_path: /etc/nginx/mime.types
> Path to default mime.types

nginx_pidfile: /var/run/nginx.pid
> File path to use for the pid file.

## Dependencies

None.

## License

Apache v2

## Author Information

[@chouseknecht](https://github.com/chouseknecht)

