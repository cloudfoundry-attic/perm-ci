FROM alpine

ARG BOSH_CLI_VERSION
ARG BBL_VERSION
ARG CRYPTDO_VERSION

RUN \
  test -n "$BOSH_CLI_VERSION" && \
  echo "$BOSH_CLI_VERSION" | echo -vq v && \
  test -n "$BBL_VERSION" && \
  echo "$BBL_VERSION" | echo -vq v && \
  test -n "$CRYPTDO_VERSION" && \
  echo "$CRYPTDOL_VERSION" | echo -vq v

RUN \
  echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache \
    bash \
    curl \
    git@edge \
    gzip \
    outils-signify \
    tar

RUN \
  cd /tmp && \
  curl -fSL \
    "https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-${BOSH_CLI_VERSION//v/}-linux-amd64" \
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
    "https://github.com/xoebus/cryptdo/releases/download/1.0.0/cryptdo-linux-${CRYPTDO_VERSION//v/}.tgz" \
    -o "cryptdo-linux-${CRYPTDO_VERSION//v/}.tgz" && \
  curl -fSL \
    "https://github.com/xoebus/cryptdo/releases/download/1.0.0/cryptdo-linux-${CRYPTDO_VERSION//v/}.tgz.sha256.sig" \
    -o cryptdo-sha256.sig && \
  signify -C -p cryptdo.pub -x cryptdo-sha256.sig && \
  mv "cryptdo-linux-${CRYPTDO_VERSION//v/}.tgz" cryptdo.tgz && \
  tar -xf cryptdo.tgz -C /usr/local/bin && \
  chmod 755 /usr/local/bin/cryptdo* && \
  rm -rf /tmp/*
