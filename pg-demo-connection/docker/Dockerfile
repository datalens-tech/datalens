FROM alpine:3.19

RUN apk add --no-cache bash postgresql-client

COPY ./init/ /init/

COPY ./docker/init.sh /init/init.sh

WORKDIR /init

ENTRYPOINT [ "./init.sh" ]
