ARG BASEIMAGE=rucio/rucio-clients
ARG BASETAG=release-32.0.0
ARG BUILD_DATE

FROM $BASEIMAGE:$BASETAG
LABEL maintainer="VRE Team - DEV image"
LABEL org.opencontainers.image.source https://github.com/vre-hub/vre-dev
LABEL org.label-schema.build-date=$BUILD_DATE

USER root

RUN yum upgrade -y \
    && yum clean all \
    && rm -rf /var/cache/yum

# EGI trust anchors
RUN curl -Lo /etc/yum.repos.d/egi-trustanchors.repo https://repository.egi.eu/sw/production/cas/1/current/repo-files/egi-trustanchors.repo \
    && yum update -y 

RUN yum clean metadata
RUN yum -y install wget ca-certificates ca-policy-egi-core

# CERN cert 
COPY ./linuxsupport7s-stable.repo /etc/yum.repos.d/
RUN yum install -y CERN-CA-certs

# ESCAPE VOMS setup
RUN mkdir -p /etc/vomses \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses
RUN mkdir -p /etc/grid-security/vomsdir/escape \
    && wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

# This is kept here just for testing from inside the container. To be removed when moved to v32 to the vre
ADD --chown=user:user rucio.cfg.escape.j2 /opt/user/rucio.cfg.j2  
# ESCAPE Rucio setup
ADD --chown=user:user rucio.default.cfg /opt/user/rucio.default.cfg

# install reana-client 
# Reana needs a gcc compiler
RUN yum install -y gcc pip python-devel \
    && pip install --upgrade pip
RUN pip install reana-client

USER user
WORKDIR /home/user

ENTRYPOINT ["/bin/bash"]


