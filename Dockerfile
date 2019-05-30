# alpine:3.9
FROM alpine@sha256:769fddc7cc2f0a1c35abb2f91432e8beecf83916c421420e6a6da9f8975464b6

RUN addgroup -g 1000 user && \
    adduser  -u 1000 -G user -D user

USER root

RUN ["apk", "add", "--no-cache", "squid=4.4-r1"]
RUN echo '' > /etc/squid/squid.conf

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

EXPOSE 8080

USER user

ENTRYPOINT ash -c 'echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf && squid -N'
