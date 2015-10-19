nginx_essential:
  cmd.run:
    - name: yum -y install gcc gcc-c++ make zlib-devel pcre-devel openssl-devel
    - unless: 
      - rpm -qa | grep pcre-devel
      - rpm -qa | grep gcc
      - rpm -qa | grep gcc-c++
      - rpm -qa | grep make
      - rpm -qa | grep zlib-devel
      - rpm -qa | grep openssl-devel
  


nginx_source:
  file.managed:
    - name: /tmp/nginx-1.6.2.tar.gz
    - unless: test -e /tmp/nginx-1.6.2.tar.gz
    - source: salt://nginx_1_6_2_0/nginx-1.6.2.tar.gz
    - user: root
    - group: root
    - mode: 644

pcre_source:
  file.managed:
    - name: /tmp/pcre-8.32.tar.gz
    - unless: test -e /tmp/pcre-8.32.tar.gz
    - source: salt://nginx_1_6_2_0/pcre-8.32.tar.gz

lua_source:
  file.managed:
    - name: /tmp/lua-nginx-module-0.9.15.tar.gz
    - unless: test -e /tmp/lua-nginx-module-0.9.15.tar.gz
    - source: salt://nginx_1_6_2_0/lua-nginx-module-0.9.15.tar.gz

ngx_source:
  file.managed:
    - name: /tmp/ngx_devel_kit-0.2.19.tar.gz
    - unless: test -e /tmp/ngx_devel_kit-0.2.19.tar.gz
    - source: salt://nginx_1_6_2_0/ngx_devel_kit-0.2.19.tar.gz

echo_source:
  file.managed:
    - name: /tmp/echo-nginx-module-0.49.tar.gz
    - unless: test -e /tmp/echo-nginx-module-0.49.tar.gz
    - source: salt://nginx_1_6_2_0/echo-nginx-module-0.49.tar.gz
 
luajit_source:
  file.managed:
    - name: /tmp/LuaJIT-2.0.2.tar.gz
    - unless: test -e /tmp/LuaJIT-2.0.2.tar.gz
    - source: salt://nginx_1_6_2_0/LuaJIT-2.0.2.tar.gz

concat_source:
  file.managed:
    - name: /tmp/nginx-http-concat.tar.gz
    - unless: test -e /tmp/nginx-http-concat.tar.gz
    - source: salt://nginx_1_6_2_0/nginx-http-concat.tar.gz

extract_nginx:
  cmd.run:
    - cwd: /tmp
    - names:
      - tar zxf /tmp/nginx-1.6.2.tar.gz
      - tar zxf /tmp/echo-nginx-module-0.49.tar.gz
      - tar zxf /tmp/ngx_devel_kit-0.2.19.tar.gz
      - tar zxf /tmp/lua-nginx-module-0.9.15.tar.gz
      - tar zxf /tmp/pcre-8.32.tar.gz
      - tar zxf /tmp/LuaJIT-2.0.2.tar.gz
      - tar xvf /tmp/nginx-http-concat.tar.gz
      - cd /tmp/LuaJIT-2.0.2 && make && make install 
    - require:
      - file: nginx_source
      - file: pcre_source
      - file: lua_source
      - file: ngx_source
      - file: echo_source
      - file: luajit_source
      - file: concat_source

ldconfig_lib:
  file.append:
    - name: /etc/ld.so.conf
    - text: "/usr/local/lib"

ldconfig:
  cmd.run:
    - name: ldconfig
    - require:
      - file: ldconfig_lib 

   

nginx_compile:
  cmd.run:
    - cwd: /tmp/nginx-1.6.2
    - names:
      - cd /tmp/nginx-1.6.2 && ./configure --user=www --group=www --prefix=/usr/local/nginx --pid-path=/var/run/nginx/nginx.pid --lock-path=/var/run/nginx/nginx.lock  --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_perl_module --with-pcre=/tmp/pcre-8.32 --with-debug --add-module=/tmp/ngx_devel_kit-0.2.19 --add-module=/tmp/echo-nginx-module-0.49 --add-module=/tmp/lua-nginx-module-0.9.15 --add-module=./nginx-http-reqstat/ --with-cc-opt='-Wno-deprecated-declarations -Wunused-variable' --add-module=/tmp/nginx-http-concat 
    - require:
      - cmd: extract_nginx
      - cmd: ldconfig
#    - unless: test -d /usr/local/nginx

nginx_make:
  cmd.run:
    - cwd: /tmp/nginx-1.6.2
    - names:
      - make
    - require:
       - cmd: nginx_compile

nginx_install:
  cmd.run:
    - cwd: /tmp/nginx-1.6.2
    - names:
      - make install
    - require:
      - cmd: nginx_make

create_vhosts:
  cmd.run:
    - names:
      - mkdir /usr/local/nginx/conf/vhosts
    - unless: test -d /usr/local/nginx/conf/vhosts
    - require:
      - cmd: nginx_install
