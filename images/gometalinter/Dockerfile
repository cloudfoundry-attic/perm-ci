FROM golang

RUN go get github.com/alecthomas/gometalinter && \
  gometalinter --install

CMD gometalinter
