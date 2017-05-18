#!/bin/bash
docker run -p 8099:80 -d -v trac:/usr/local/ngtrac -h trac --name trac trac
