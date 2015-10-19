libevent_source:
  file.managed:
    - name: /tmp/libevent-2.0.22-stable.tar.gz 
    - unless: test -e /tmp/libevent-2.0.22-stable.tar.gz
    - source: salt://memcached_1_4_2/libevent-2.0.22-stable.tar.gz
    - user: root
    - group: root
    - mode: 644


libevent_extract:
  cmd.run:
    - cwd: /tmp
    - names:
      - tar zxf /tmp/libevent-2.0.22-stable.tar.gz
    - require:
      - file: libevent_source


libevent_make:
  cmd.run:
    - cwd: /tmp/libevent-2.0.22-stable
    - names:
      - ./configure --prefix=/usr/local/libevent && make && make install
      - ln -sv /usr/local/libevent/include /usr/include/libevent
      - echo "/usr/local/libevent/lib" > /etc/ld.so.conf.d/libevent.conf
      - /sbin/ldconfig

memcached_source:
  file.managed:
    - name: /tmp/memcached-1.4.24.tar.gz
    - unless: test -e /tmp/memcached-1.4.24.tar.gz
    - source: salt://memcached_1_4_2/memcached-1.4.24.tar.gz
    - user: root
    - group: root
    - mode: 644
    

memcached_extract:
  cmd.run:
    - cwd: /tmp
    - names:
      - tar zxf /tmp/memcached-1.4.24.tar.gz
    - require:
      - file: memcached_source
      - pkg: memcached_pkg

memcached_configure:
  cmd.run:
    - cwd: /tmp/memcached-1.4.24
    - names:
      - ./configure --prefix=/usr/local/ && make  && make install
      - ln -sv /usr/local/memcached/include /usr/include/memcach
    - require:
      - cmd: memcached_extract
     

memcached_init:
  file.managed:
    - name: /etc/init.d/memcached
    - unless: test -e /etc/init.d/memcached
    - source: salt://memcached_1_4_2/memcached
    - user: root
    - group: root
    - mode: 644

memcached_service:
  cmd.run:
    - names:
      - chkconfig --add /etc/init.d/memcached
      - chkconfig memcached on
      - chkconfig --list memcached
      - service memcached start
    - require:
      - file: memcached_init

