#!/bin/bash

ansible-playbook build.yml | tee build.out
grep failed=0 build.out >/dev/null

if [ "$?" == "0" ]; then
    # if all looks good, give it a go
    echo "Build completed successfully. Starting the project..."
    ansible-container run
 fi 
