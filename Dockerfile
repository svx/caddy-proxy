#
# Dockerfile for Caddy https://caddyserver.com/
# Addopted from https://github.com/abiosoft/caddy-docker
#
FROM alpine:latest

ARG container_version=0.0.0.0
ENV DOCKER_GEN_VERSION 0.7.3


LABEL maintainer "Sven <sven@testthedocs.org>" \
    org.label-schema.vendor = "TestTheDocs" \
    caddy_version="0.10.7" \
    architecture="amd64" \
    build_version="$container_version"

RUN builddeps=' \
        tar \
        curl \
	wget \
	bash \
        '\
        && apk --no-cache add \
        $builddeps \
        git \
        tini \
        openssh-client \
	&& curl --silent --show-error --fail --location \
		--header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
		"https://caddyserver.com/download/linux/amd64?plugins=http.minify" \
	| tar --no-same-owner -C /usr/bin/ -xz caddy \
	&& chmod 0755 /usr/bin/caddy \
        && /usr/bin/caddy -version
	#&& apk del --purge $builddeps

# Install Forego
ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
    && rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY Procfile /srv/Procfile
COPY caddyfile.tpl /srv/caddyfile.tpl
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

WORKDIR /srv

ENV DOCKER_HOST unix:///tmp/docker.sock

#VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam"]
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]

#ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/caddy"]
#CMD ["--conf", "/etc/Caddyfile"]
