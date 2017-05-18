#!/bin/bash
if [ $# -ne 2 ]
then
    echo "Please specify arguments for username/password"
    exit 1
fi
docker build -t trac --build-arg ADMIN_USER=$1 --build-arg ADMIN_PASSWORD=$2 .
