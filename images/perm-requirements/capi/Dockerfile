FROM ruby:2.4
MAINTAINER https://github.com/cloudfoundry/capi-dockerfiles

RUN gem install bundler

RUN set -eu; \
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
	key="A4A9406876FCBD3C456770C88C718D3B5072E1F5"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/mysql.gpg; \
	apt-key list > /dev/null

ENV MYSQL_MAJOR 5.7
ENV MYSQL_VERSION 5.7.23-1debian9

RUN echo "deb http://repo.mysql.com/apt/debian/ stretch mysql-${MYSQL_MAJOR}" > /etc/apt/sources.list.d/mysql.list

RUN set -eu \
    && echo "mysql-server mysql-server/root_password password password" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections \
    && echo "mysql-community-server	mysql-community-server/root-pass	password password" | debconf-set-selections \
    && echo "mysql-community-server	mysql-community-server/re-root-pass	password password" | debconf-set-selections \
    && echo "mysql-community-server	mysql-community-server/data-dir	note" | debconf-set-selections \
    && echo "mysql-community-server	mysql-community-server/remove-data-dir	boolean	false" | debconf-set-selections \
    && apt-get update \
    && apt-get -y install \
           mysql-server="${MYSQL_VERSION}" \
           postgresql-contrib \
           postgresql \
           apt-transport-https \
           software-properties-common \
    && apt-get clean \
    && chmod 755 /var/lib/mysql \
    && sed -i 's/peer/trust/' "$(find /etc/postgresql -name pg_hba.conf)" \
    && sed -i 's/md5/trust/' "$(find /etc/postgresql -name pg_hba.conf)" \
    && service mysql restart \
    && service postgresql restart \
    && echo 'CREATE DATABASE cc_test;' | mysql -u root -ppassword \
    && createdb -U postgres cc_test \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install MS SQL CLI
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install nodejs && \
  npm install -g sql-cli

# Install docker in order to run nested MS SQL docker image
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
  apt-key fingerprint 0EBFCD88 && \
  add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable" && \
  apt-get update && \
  apt-get -y install docker-ce && \
  apt-get clean

ENV GOPATH $HOME/go
ENV PATH $HOME/go/bin:/usr/local/go/bin:$PATH
RUN \
  wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz -P /tmp && \
  tar xzvf /tmp/go1.10.3.linux-amd64.tar.gz -C /usr/local && \
  mkdir $GOPATH && \
  rm -rf /tmp/*

RUN go get github.com/nats-io/gnatsd

RUN set -ex \
    && apt-get update \
    && apt-get -y install \
        vim \
        unzip \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -ex \
    && wget https://raw.githubusercontent.com/cloudfoundry/cloud_controller_ng/master/Gemfile.lock \
    && wget https://raw.githubusercontent.com/cloudfoundry/cloud_controller_ng/master/Gemfile \
    && bundle install \
    && rm Gemfile \
    && rm Gemfile.lock \
    && rm -rf /tmp/* /var/tmp/*
