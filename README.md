#nginx-container 

Adds an nginx service to your [Ansible Container](https://github.com/ansible/ansible-container) project. Run the following commands
to install the service:

```
# Set the working directory to your Ansible Container project root
$ cd myproject

# Install the service
$ ansible-container install chouseknecht.nginx-container
```

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

    nginx_vhosts: []

A list of vhost definitions (server blocks) for Nginx virtual hosts. If left empty, you will need to supply your own virtual host configuration. See the commented example in `defaults/main.yml` for available server options. If you have a large number of customizations required for your server definition(s), you're likely better off managing the vhost configuration file yourself, leaving this variable set to `[]`.

    nginx_vhosts:
      - listen: "80 default_server"
        server_name: "example.com"
        root: "/var/www/example.com"
        index: "index.php index.html index.htm"
        error_page: ""
        access_log: ""
        error_log: ""
        extra_parameters: |
          location ~ \.php$ {
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:/var/run/php5-fpm.sock;
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include fastcgi_params;
          }

An example of a fully-populated nginx_vhosts entry, using a `|` to declare a block of syntax for the `extra_parameters`.

Please take note of the indentation in the above block. The first line should be a normal 2-space indent. All other lines should be indented normally relative to that line. In the generated file, the entire block will be 4-space indented. This style will ensure the config file is indented correctly.

    nginx_remove_default_vhost: false

Whether to remove the 'default' virtualhost configuration supplied by Nginx. Useful if you want the base `/` URL to be directed at one of your own virtual hosts configured in a separate .conf file.

    nginx_vhosts_filename: "vhosts.conf"

The filename to use to store vhosts configuration. If you run the role multiple times (e.g. include the role with `with_items`), you can change the name for each run, effectively creating a separate vhosts file per vhost configuration.

    nginx_upstreams: []

If you are configuring Nginx as a load balancer, you can define one or more upstream sets using this variable. In addition to defining at least one upstream, you would need to configure one of your server blocks to proxy requests through the defined upstream (e.g. `proxy_pass http://myapp1;`). See the commented example in `defaults/main.yml` for more information.

    nginx_worker_processes: "{{ ansible_processor_vcpus|default(ansible_processor_count) }}"
    nginx_worker_connections: "1024"
    nginx_multi_accept: "off"

`nginx_worker_processes` should be set to the number of cores present on your machine (if the default is incorrect, find this number with `grep processor /proc/cpuinfo | wc -l`). `nginx_worker_connections` is the number of connections per process. Set this higher to handle more simultaneous connections (and remember that a connection will be used for as long as the keepalive timeout duration for every client!). You can set `nginx_multi_accept` to `on` if you want Nginx to accept all connections immediately.

    nginx_error_log: "/var/log/nginx/error.log warn"
    nginx_access_log: "/var/log/nginx/access.log main buffer=16k"

Configuration of the default error and access logs. Set to `off` to disable a log entirely.

    nginx_sendfile: "on"
    nginx_tcp_nopush: "on"
    nginx_tcp_nodelay: "on"

TCP connection options. See [this blog post](https://t37.net/nginx-optimization-understanding-sendfile-tcp_nodelay-and-tcp_nopush.html) for more information on these directives.

    nginx_keepalive_timeout: "65"
    nginx_keepalive_requests: "100"

Nginx keepalive settings. Timeout should be set higher (10s+) if you have more polling-style traffic (AJAX-powered sites especially), or lower (<10s) if you have a site where most users visit a few pages and don't send any further requests.

    nginx_client_max_body_size: "64m"

This value determines the largest file upload possible, as uploads are passed through Nginx before hitting a backend like `php-fpm`. If you get an error like `client intended to send too large body`, it means this value is set too low.

    nginx_server_names_hash_bucket_size: "64"

If you have many server names, or have very long server names, you might get an Nginx error on startup requiring this value to be increased.

    nginx_proxy_cache_path: ""

Set as the `proxy_cache_path` directive in the `nginx.conf` file. By default, this will not be configured (if left as an empty string), but if you wish to use Nginx as a reverse proxy, you can set this to a valid value (e.g. `"/var/cache/nginx keys_zone=cache:32m"`) to use Nginx's cache (further proxy configuration can be done in individual server configurations).

    nginx_extra_http_options: ""

Extra lines to be inserted in the top-level `http` block in `nginx.conf`. The value should be defined literally (as you would insert it directly in the `nginx.conf`, adhering to the Nginx configuration syntax - such as `;` for line termination, etc.), for example:

    nginx_extra_http_options: |
      proxy_buffering    off;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Scheme $scheme;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   Host $http_host;

## Dependencies

None.

## License

Apache v2

## Author Information

[@chouseknecht](https://github.com/chouseknecht)

