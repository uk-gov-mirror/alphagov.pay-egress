FROM govukpay/alpine:latest-master

USER root


RUN apk add --no-cache squid=3.5.27-r0 openssh sudo shadow tcpdump

RUN echo '' > /etc/squid/squid.conf
RUN echo 'ALL            ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

RUN mkdir /squid && chown -R user /squid && chown -R user /etc/squid/squid.conf

RUN mkdir -p /home/user/etc/ssh

RUN setcap cap_net_raw,cap_net_admin=eip $(which tcpdump)
RUN chown user:user $(which tcpdump)

ADD sshd_config /home/user/etc/ssh/

RUN usermod -s /bin/ash user

RUN chown -R user /home/user

ADD wrapper.sh /usr/local/bin

EXPOSE 8080
EXPOSE 2222

USER user

ENTRYPOINT wrapper.sh
