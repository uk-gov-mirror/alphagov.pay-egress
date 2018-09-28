FROM govukpay/alpine:latest-master

USER root

RUN apk add --no-cache squid=3.5.27-r0
RUN echo '' > /etc/squid/squid.conf

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

RUN touch /var/log/squid/access.log /var/log/squid/cache.log && chown -R user /var/log/squid

EXPOSE 8080

USER user

ENTRYPOINT ash -c 'echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf && squid -z && squid && tail -f /var/log/squid/access.log /var/log/squid/cache.log'
