FROM ubuntu:18.04
MAINTAINER Lucas Mundim "lucas.mundim@gmail.com"

# Versions
ENV NGINX_VERSION 1.12.2
ENV NGINX_PUSH_STREAM_VERSION 0.5.4
ENV NGINX_DEVEL_KIT_VERSION 0.3.0
ENV NGINX_LUA_VERSION 0.10.11
ENV LUA_RESTY_REDIS 0.26
ENV LUA_RESTY_REDIS_CONNECTOR 0.06

ENV DEBIAN_FRONTEND noninteractive
ENV PATH=$PATH:/usr/local/nginx/sbin

ENV LUAJIT_LIB=/usr/lib/x86_64-linux-gnu
ENV LUAJIT_INC=/usr/include/luajit-2.1

# create directories
RUN mkdir -p /src /config /logs

# update and upgrade packages
RUN apt-get update && apt-get install -y \
  build-essential \
  libluajit-5.1-dev \
  libpcre3-dev \
  libssl-dev \
  luajit \
  wget \
  zlib1g-dev \
  && apt-get clean

# get nginx source
RUN cd /src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && tar zxf nginx-${NGINX_VERSION}.tar.gz

# get nginx-push-stream module
RUN cd /src && wget https://github.com/wandenberg/nginx-push-stream-module/archive/${NGINX_PUSH_STREAM_VERSION}.tar.gz && tar zxf ${NGINX_PUSH_STREAM_VERSION}.tar.gz

# get nginx-devel-kit module
RUN cd /src && wget https://github.com/simpl/ngx_devel_kit/archive/v${NGINX_DEVEL_KIT_VERSION}.tar.gz && tar zxf v${NGINX_DEVEL_KIT_VERSION}.tar.gz

# get nginx-lua module
RUN cd /src && wget https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_VERSION}.tar.gz && tar zxf v${NGINX_LUA_VERSION}.tar.gz

# get lua-resty-redis
RUN cd /src && mkdir -p /lua-modules/lua-resty-redis && wget https://github.com/openresty/lua-resty-redis/archive/v${LUA_RESTY_REDIS}.tar.gz && tar zxf v${LUA_RESTY_REDIS}.tar.gz -C /lua-modules/lua-resty-redis --strip 1

# get lua-resty-redis-connector
RUN cd /src && mkdir -p /lua-modules/lua-resty-redis-connector && wget https://github.com/pintsized/lua-resty-redis-connector/archive/v${LUA_RESTY_REDIS_CONNECTOR}.tar.gz && tar zxf v${LUA_RESTY_REDIS_CONNECTOR}.tar.gz -C /lua-modules/lua-resty-redis-connector --strip 1

# configure nginx
RUN cd /src/nginx-${NGINX_VERSION} && ./configure \
  --add-module=/src/nginx-push-stream-module-${NGINX_PUSH_STREAM_VERSION} \
  --add-module=/src/ngx_devel_kit-${NGINX_DEVEL_KIT_VERSION} \
  --add-module=/src/lua-nginx-module-${NGINX_LUA_VERSION} \
  --conf-path=/config/nginx.conf

# compile nginx
RUN cd /src/nginx-${NGINX_VERSION} && make && make install

# cleanup
RUN rm -Rf /src

# Use same uid as boot2docker/docker-machine
RUN usermod -u 1000 www-data

ADD nginx.conf /config/nginx.conf

EXPOSE 80
EXPOSE 443

CMD "nginx"
