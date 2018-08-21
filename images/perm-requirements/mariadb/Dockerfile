FROM cfperm/requirements:base

# Adapted from bosh's CI:
# https://github.com/cloudfoundry/bosh/blob/master/ci/docker/main-mysql/Dockerfile

ENV DEBIAN_FRONTEND noninteractive

RUN \
  echo "mysql-server mysql-server/root_password password password" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections && \
  echo "mysql-community-server	mysql-community-server/root-pass	password password" | debconf-set-selections && \
  echo "mysql-community-server	mysql-community-server/re-root-pass	password password" | debconf-set-selections && \
  echo "mysql-community-server	mysql-community-server/data-dir	note" | debconf-set-selections && \
  echo "mysql-community-server	mysql-community-server/remove-data-dir	boolean	false" | debconf-set-selections

RUN \
  apt-get update -qq && \
  apt-get install -yqq --no-install-recommends \
    software-properties-common \
    dirmngr && \
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 && \
  add-apt-repository \
    'deb [arch=amd64,i386,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.2/debian stretch main' && \
  apt-get update -qq && \
  apt-get install -yqq --no-install-recommends \
    mariadb-server && \
  apt-get clean
