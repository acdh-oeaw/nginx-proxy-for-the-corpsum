FROM nginx:stable-alpine-slim

# Add and setup entrypoint
COPY custom /custom

ENV PROXY_FOR https://demo-amc.acdh.oeaw.ac.at/bonito/
ENV ALLOW_ORIGIN ~^https?://(corpsum\.acdh-dev\.oeaw\.ac\.at|localhost:3000)$

# Remove default configuration and add our custom Nginx configuration files
RUN rm /usr/sbin/nginx* &&\
    apk del nginx &&\
    apk add --no-cache \
        links \
        vim \
        nano \
        openssl \
        bash \
        coreutils \
        tini \
        curl \
        shadow \
        nginx \
        nginx-mod-http-headers-more && \
    rm -rf /tmp/* && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    rm -rf /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh && \
    cp /custom/99-envsubst-PROXY_FOR.sh /docker-entrypoint.d && \
    chmod a+x /docker-entrypoint.d/*.sh &&\
    cp /custom/nginx.conf /custom/auth /etc/nginx/ && \
    mkdir -p /etc/nginx/conf.d &&\
    cp /custom/noske /etc/nginx/noske.conf.template && \
    envsubst '$PROXY_FOR $ALLOW_ORIGIN' < /custom/noske > /etc/nginx/conf.d/noske.conf && \
    cp /custom/security.conf /etc/nginx/conf.d/security.conf && \
    rm -fR /custom && \
    mkdir -p /var/cache/nginx/ts_cache && \
    chown -R nginx:nginx /etc/nginx/conf.d /var/cache/nginx /var/run

#@INJECT_USER@

#Healthcheck to make sure container is ready
HEALTHCHECK CMD curl --fail http://localhost || exit 1