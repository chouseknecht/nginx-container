#!/bin/bash 

base=$(basename ${PWD})

if [ "${base}" != "tests" ]; then
    echo "Are you in the tests directory?"
    exit 1
fi

if [ -d "ansible" ]; then
    rm -rf ansible
fi

ansible-container init 
ansible-container install git+https://github.com/chouseknecht/nginx-container.git,$(git rev-parse HEAD)
ansible-container build
