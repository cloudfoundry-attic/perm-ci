FROM ubuntu:xenial

ARG BOSH_CLI_VERSION
ARG BBL_VERSION
ARG CRYPTDO_VERSION

RUN \
  test -n "$BOSH_CLI_VERSION" && \
  echo "$BOSH_CLI_VERSION" | grep -vq v && \
  test -n "$BBL_VERSION" && \
  echo "$BBL_VERSION" | grep -q v && \
  test -n "$CRYPTDO_VERSION" && \
  echo "$CRYPTDO_VERSION" | grep -vq v

RUN \
  apt-get update -qq && \
  apt-get install -yqq --no-install-recommends \
    software-properties-common && \
  add-apt-repository ppa:git-core/ppa && \
  apt-get install -yqq --no-install-recommends \
    ca-certificates \
    curl \
    git \
    signify-openbsd && \
  rm -rf /var/lib/apt/lists/*

RUN \
  cd /tmp && \
  curl -fSL \
    "https://releases.hashicorp.com/terraform/0.10.3/terraform_0.10.3_linux_amd64.zip" \
    -o terraform.zip && \
  unzip terraform.zip && \
  chmod 755 terraform && \
  mv terraform /usr/local/bin && \
  rm -rf /tmp/*

RUN \
  cd /tmp && \
  curl -fSL \
    "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_CLI_VERSION}-linux-amd64" \
    -o /usr/local/bin/bosh && \
  chmod 755 /usr/local/bin/bosh && \
  rm -rf /tmp/*

RUN \
  cd /tmp && \
  curl -fSL \
    "https://github.com/cloudfoundry/bosh-bootloader/releases/download/${BBL_VERSION}/bbl-${BBL_VERSION}_linux_x86-64" \
    -o /usr/local/bin/bbl && \
  chmod 755 /usr/local/bin/bbl && \
  rm -rf /tmp/*

RUN \
  cd /tmp && \
  curl -fSL \
    "https://xoeb.us/keys/cryptdo.pub" \
    -o cryptdo.pub && \
  curl -fSL \
    "https://github.com/xoebus/cryptdo/releases/download/1.0.0/cryptdo-linux-${CRYPTDO_VERSION}.tgz" \
    -o "cryptdo-linux-${CRYPTDO_VERSION}.tgz" && \
  curl -fSL \
    "https://github.com/xoebus/cryptdo/releases/download/1.0.0/cryptdo-linux-${CRYPTDO_VERSION}.tgz.sha256.sig" \
    -o cryptdo-sha256.sig && \
  signify-openbsd -C -p cryptdo.pub -x cryptdo-sha256.sig && \
  mv "cryptdo-linux-${CRYPTDO_VERSION}.tgz" cryptdo.tgz && \
  tar -xf cryptdo.tgz -C /usr/local/bin && \
  chmod 755 /usr/local/bin/cryptdo* && \
  rm -rf /tmp/*
