FROM golang

RUN \
  apt-get update -qq && \
  apt-get install -yqq --no-install-recommends \
    apparmor && \
  apt-get clean
