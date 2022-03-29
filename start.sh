#!/bin/sh

# check if port variable is set or go with default
if [ -z ${PORT+x} ]; then echo "PORT variable not defined, leaving N8N to default port."; else export N8N_PORT=$PORT; echo "N8N will start on '$PORT'"; fi


if [ -d /root/.n8n ] ; then
  chmod o+rx /root
  chown -R node /root/.n8n
  ln -s /root/.n8n /home/node/
fi

chown -R node /home/node

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  COMMAND=$1;

  if [[ "$COMMAND" == "n8n" ]]; then
    shift
    exec su-exec node n8n "$@"
  else
    exec su-exec node "$@"
  fi

else
# Got started without arguments
exec su-exec node n8n
fi
