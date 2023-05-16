#!/bin/sh
if [ "$PROXY_FOR"x != "x" ]
then 
  echo "Setting proxy target to $PROXY_FOR/run.cgi"
  envsubst \$PROXY_FOR < /etc/nginx/noske.conf.template > /etc/nginx/conf.d/noske.conf
fi