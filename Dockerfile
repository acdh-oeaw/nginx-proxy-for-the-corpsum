FROM nginx:1.16.0-alpine

# Add and setup entrypoint
COPY custom /custom

# Remove default configuration and add our custom Nginx configuration files
RUN apk add --no-cache \
        links \
        vim \
        nano \
        openssl \
        bash \
        coreutils \
        tini \
        curl \
        shadow && \
    rm -rf /tmp/* && \
    rm /etc/nginx/conf.d/default.conf && \
    cp /custom/noske /etc/nginx/conf.d/noske.conf && \
    cp /custom/security.conf /etc/nginx/conf.d/security.conf && \
    rm -fR /custom && \
    mkdir -p /var/cache/nginx/ts_cache && \
    chown -R nginx:nginx /etc/nginx/conf.d /var/cache/nginx /var/run

#@INJECT_USER@

#Healthcheck to make sure container is ready
HEALTHCHECK CMD curl --fail http://localhost || exit 1

ENTRYPOINT ["nginx", "-g", "daemon off;"]
