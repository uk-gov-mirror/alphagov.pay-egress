FROM govukpay/alpine:3.9

USER root

RUN apk add --no-cache squid=4.4-r1
RUN echo '' > /etc/squid/squid.conf

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

EXPOSE 8080

USER user

ENTRYPOINT ash -c 'echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf && squid -N'
