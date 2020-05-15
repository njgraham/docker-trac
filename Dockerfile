FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV PKG_RESOURCES_CACHE_ZIP_MANIFESTS=1

ARG ADMIN_USER
ARG ADMIN_PASSWORD

ARG TRAC_VERSION=1.4.1
ARG TRAC_ENV=/usr/local/ngtrac
ARG PASSWD_FILE=${TRAC_ENV}/.htpasswd
ARG PROJECT_NAME=ngtrac

RUN apt-get update && \
    apt-get install -y git python-setuptools python-pip apache2-utils graphviz && \
    pip install --upgrade pip && \
    pip install trac==${TRAC_VERSION} TracMasterTickets

RUN trac-admin ${TRAC_ENV} initenv ${PROJECT_NAME} sqlite:db/trac.db && \
    trac-admin ${TRAC_ENV} permission add ${ADMIN_USER} TRAC_ADMIN && \
    htpasswd -cb ${PASSWD_FILE} ${ADMIN_USER} ${ADMIN_PASSWORD}

COPY trac.ini ${TRAC_ENV}/conf/
COPY Gear_Light.png ${TRAC_ENV}/htdocs/
RUN trac-admin ${TRAC_ENV} upgrade
RUN trac-admin ${TRAC_ENV} wiki upgrade

ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Argument/variable substitution doesn't seem to work here.
CMD tracd -s --port=80 --basic-auth="ngtrac,/usr/local/ngtrac/.htpasswd,realm" /usr/local/ngtrac