FROM alpine

ADD ["perm", "/usr/bin/perm"]
ADD ["certs/perm.service.cf.internal.crt", "/etc/certs/perm.service.cf.internal.crt"]
ADD ["certs/perm.service.cf.internal.key", "/etc/certs/perm.service.cf.internal.key"]

ENTRYPOINT ["perm", "--tls-certificate", "/etc/certs/perm.service.cf.internal.crt", "--tls-key", "/etc/certs/perm.service.cf.internal.crt"]
