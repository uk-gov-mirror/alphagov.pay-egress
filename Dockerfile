# alpine 3.12.0
FROM alpine@sha256:a15790640a6690aa1730c38cf0a440e2aa44aaca9b0e8931a9f2b0d7cc90fd65

RUN addgroup -g 1000 user && \
    adduser  -u 1000 -G user -D user

USER root

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN ["apk", "add", "--no-cache", "squid@edge", "tini"]
RUN echo '' > /etc/squid/squid.conf

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

EXPOSE 8080

USER user

ENTRYPOINT tini -- ash -c 'echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf && exec squid -N'
