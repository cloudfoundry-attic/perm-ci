FROM alpine

ADD ["perm", "/usr/bin/perm"]
ADD ["certs/perm.crt", "/etc/certs/perm.crt"]
ADD ["certs/perm.key", "/etc/certs/perm.key"]

ENTRYPOINT ["perm", "--tls-certificate", "/etc/certs/perm.crt", "--tls-key", "/etc/certs/perm.key"]
