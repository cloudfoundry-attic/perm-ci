FROM cfperm/requirements:base

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  apt-get install -yqq --no-install-recommends \
    lsb-release && \
  apt-get clean

RUN wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb && \
  dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb && \
  apt-get update && \
  apt-get install -yqq --no-install-recommends \
    percona-server-server-5.7 \
    percona-server-client-5.7 && \
  apt-get clean
