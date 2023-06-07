#!/usr/bin/env sh

set -e

apt-get install -y tini netcat

confd="/etc/opt/simplex"
logd="/var/opt/simplex/"

# Check if smp-server has been initialized
if [ ! -f "$confd/smp-server.ini" ]; then
  # Set a 15 digit server password. See the comments in smp-server.ini for a description of what this does
  export PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 15) 

  # Init certificates and configs
  smp-server init -y -l --password $PASS

  else
    export PASS=$(grep -i "^create_password" $confd/smp-server.ini | awk -F ':' '{print $2}' | awk '{$1=$1};1')
fi

# Backup store log just in case
[ -f "$logd/smp-server-store.log" ] && cp "$logd"/smp-server-store.log "$logd"/smp-server-store.log."$(date +'%FT%T')"

TOR_ADDRESS=$(sed -n -e 's/^tor-address: \(.*\)/\1/p' /root/start9/config.yaml)
SERVER_FINGERPRINT=$(cat $confd/fingerprint)

SMP_URL="smp://$SERVER_FINGERPRINT:$PASS@$TOR_ADDRESS"

mkdir -p /root/start9

cat << EOF > /root/start9/stats.yaml
---
version: 2
data:
  Server Address:
    type: string
    value: $SMP_URL
    description: Your SMP Server address, used in client applications.
    copyable: true
    qr: true
    masked: true
EOF

# Finally, run smp-sever. Notice that "exec" here is important:
# smp-server replaces our helper script, so that it can catch INT signal
exec tini -s -- smp-server start +RTS -N -RTS