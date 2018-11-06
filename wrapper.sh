if [ ! -f "~/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f ~/etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "~/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f ~/etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "~/var/run/sshd" ]; then
  mkdir -p ~/var/run/sshd
fi

mkdir -p ~/.ssh
echo "$SSH_PUB_KEY"

echo "$SSH_PUB_KEY" | base64 -d > ~/.ssh/authorized_keys

/usr/sbin/sshd -f ~/etc/ssh/sshd_config

status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sshd: $status"
  exit $status
fi

echo "$SQUID_CONFIG" | base64 -d > /etc/squid/squid.conf
squid -z && squid -N
