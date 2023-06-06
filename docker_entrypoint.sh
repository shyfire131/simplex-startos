#!/usr/bin/env sh
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$filebrowser_process" 2>/dev/null
}

apt-get install tini

confd="/etc/opt/simplex"
logd="/var/opt/simplex/"

export ADDR="0.0.0.0"

# Check if server has been initialized
if [ ! -f "$confd/smp-server.ini" ]; then
  # If not, determine ip or domain
  case "$ADDR" in
    '') printf "Please specify \$ADDR environment variable.\n"; exit 1 ;;
    *[a-zA-Z]*)
      case "$ADDR" in
        *:*) set -- --ip "$ADDR" ;;
        *) set -- -n "$ADDR" ;;
      esac
      ;;
    *) set -- --ip "$ADDR" ;;
  esac

  export PASS=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 15) #set a 15 digit server password. See the comments in smp-server.ini for a description of what this does

  # Optionally, set password
  case "$PASS" in
    '') set -- "$@" --no-password ;;
    *) set -- "$@" --password "$PASS" ;;
  esac

  # And init certificates and configs
  smp-server init -y -l "$@"

  else
    export PASS=$(grep -i "^create_password" $confd/smp-server.ini | awk -F ':' '{print $2}' | awk '{$1=$1};1')
fi

# Backup store log just in case
[ -f "$logd/smp-server-store.log" ] && cp "$logd"/smp-server-store.log "$logd"/smp-server-store.log."$(date +'%FT%T')"

TOR_ADDRESS=$(sed -n -e 's/^tor-address: \(.*\)/\1/p' /root/start9/config.yaml)
SERVER_FINGERPRINT=$(cat $confd/fingerprint)

SMP_URL="smp://$SERVER_FINGERPRINT:$PASS@$TOR_ADDRESS"

mkdir -p /root/start9
echo 'version: 2' > /root/start9/stats.yaml
echo 'data:' >> /root/start9/stats.yaml
echo '  Server Address:' >> /root/start9/stats.yaml
echo '    type: string' >> /root/start9/stats.yaml
echo '    value: "'"$SMP_URL"'"' >> /root/start9/stats.yaml
echo '    description: This is your randomly-generated, default password. TODO long description here.' >> /root/start9/stats.yaml
echo '    copyable: true' >> /root/start9/stats.yaml
echo '    masked: true' >> /root/start9/stats.yaml
echo '    qr: true' >> /root/start9/stats.yaml

# Finally, run smp-sever. Notice that "exec" here is important:
# smp-server replaces our helper script, so that it can catch INT signal
exec tini -s -- smp-server start +RTS -N -RTS