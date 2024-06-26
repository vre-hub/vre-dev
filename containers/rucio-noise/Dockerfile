ARG BASEIMAGE=rucio/rucio-clients
#ARG BASEIMAGE=rucio/rucio-server
ARG BASETAG=release-32.0.0
ARG BUILD_DATE

FROM $BASEIMAGE:$BASETAG
LABEL maintainer="VRE TEAM - DEV image"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre-dev
LABEL org.label-schema.build-date=$BUILD_DATE

USER root

# cleanup yum cache
RUN yum upgrade -y \
    && yum clean all \
    && rm -rf /var/cache/yum

# install useful tools
RUN yum -y install git htop wget voms-clients-cpp
RUN pip install --upgrade pip

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/egi-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo \
    && yum update -y 

RUN yum -y install gfal2* python3-gfal2 xrootd-client voms-clients-java 
RUN yum -y install ca-certificates ca-policy-egi-core

RUN pwd
RUN ls -lrt

# Install CERN CA certs from CERN maintained mirrors
# This will add a `CERN-bundle.pem` file (among others) into `/etc/pki/tls/certs/`
COPY ./linuxsupport7s-stable.repo /etc/yum.repos.d/
RUN yum install -y CERN-CA-certs

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses \
    && mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# Install latest kubectl
RUN curl -o /usr/bin/kubectl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x /usr/bin/kubectl

# From here 
RUN yum install -y gcc pip python-devel \
    && pip install --upgrade pip
RUN pip install reana-client

# ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2

# Overwritting the path in rucio init script
ADD init_rucio.sh /etc/profile.d/init_rucio.sh

# To here testing the reana-client base image

WORKDIR /home

COPY ./produce_noise.sh requirements.txt rses.txt /home/
RUN chmod +x ./produce_noise.sh
RUN pip install -r /home/requirements.txt

ENTRYPOINT ["/bin/bash"]



