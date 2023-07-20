#!/bin/sh
if [ "$PROXY_FOR"x != "x" ]
then 
  echo "Setting proxy target to $PROXY_FOR/run.cgi, allow-origin $ALLOW_ORIGIN"
  envsubst \$PROXY_FOR \$ALLOW_ORIGIN < /etc/nginx/noske.conf.template > /etc/nginx/conf.d/noske.conf
fi