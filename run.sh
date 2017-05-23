#!/bin/bash
docker run -p 8099:80 -d -v trac:/usr/local/ngtrac -v /etc/localtime:/etc/localtime:ro -h trac --name trac trac
