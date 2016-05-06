FROM alpine:3.3

RUN apk add --update-cache bash curl jq && \
    apk add --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ xmlstarlet && \
    rm -rf /var/cache/apk/*

ADD check in out /opt/resource/

CMD /bin/bash
