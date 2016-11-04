#!/bin/bash

if [ -d "/nginx_templates" ]; then
    # Run conf files through envsubst to template environment variables into
    # the files. `man envsubst` for help using envsubst.  
    for file in /nginx_templates/*
    do
        echo "Copying ${file} to /etc/nginx"
        f=$(basename ${file})
        envsubst < ${file} > /etc/nginx/${f}
    done
fi
 
exec "$@"
