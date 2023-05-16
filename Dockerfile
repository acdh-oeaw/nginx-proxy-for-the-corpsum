FROM nginx:stable-alpine-slim

# Add and setup entrypoint
COPY custom /custom

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
    cp /custom/nginx.conf /etc/nginx/ && \
    mkdir -p /etc/nginx/conf.d &&\
    cp /custom/noske /etc/nginx/conf.d/noske.conf && \
    cp /custom/security.conf /etc/nginx/conf.d/security.conf && \
    rm -fR /custom && \
    mkdir -p /var/cache/nginx/ts_cache && \
    chown -R nginx:nginx /etc/nginx/conf.d /var/cache/nginx /var/run

#@INJECT_USER@

#Healthcheck to make sure container is ready
HEALTHCHECK CMD curl --fail http://localhost || exit 1

ENTRYPOINT ["nginx", "-g", "daemon off;"]
