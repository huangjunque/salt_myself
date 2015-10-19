include:
  - nginx_1_6_2_0.install

nginx_conf:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://nginx_1_6_2_0/nginx.module


nginx_user:
  cmd.run:
    - names: 
      - groupadd www && useradd -g www -s /sbin/nologin -M www
    - unless: id www

nginx_service:
  file.managed:
    - name: /etc/init.d/nginx
    - user: root
    - mode: 755
    - source: salt://nginx_1_6_2_0/nginx
#  cmd.run:
#    - names:
#      - /sbin/chkconfig --add nginx
#      - /sbin/chkconfig nginx on
#    - unless: /sbin/chkconfig --list nginx
#    - require:
#      - cmd: nginx_user

pkill_nginx:
  cmd.run:
    - names:
      - pkill -f nginx
    - onlyif: pgrep -lf nginx

nginx_start:
  cmd.run:
    - names:
      - mkdir -p /data/www/check
      - /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
    - require:
      - cmd: pkill_nginx 
 
     
    
   

