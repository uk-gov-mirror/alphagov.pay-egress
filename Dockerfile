FROM alpine@sha256:6a92cd1fcdc8d8cdec60f33dda4db2cb1fcdcacf3410a8e05b3741f44a9b5998

RUN addgroup -g 1000 user && \
    adduser  -u 1000 -G user -D user

USER root

RUN ["apk", "add", "--no-cache", "squid=4.8-r0", "tini"]
RUN echo '' > /etc/squid/squid.conf

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

EXPOSE 8080

USER user

ENTRYPOINT tini -- ash -c 'echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf && exec squid -N'
