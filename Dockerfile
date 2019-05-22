# govukpay/alpine:3.9
FROM govukpay/alpine@sha256:7c98b51d3496a69d6f367a5c707287d49a202e304f964e17bd75eaacc960c7dc

USER root

RUN apk add --no-cache squid=4.4-r1
RUN echo '' > /etc/squid/squid.conf

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

EXPOSE 8080

USER user

ENTRYPOINT ash -c 'echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf && squid -N'
