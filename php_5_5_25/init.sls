php_source:
  file.managed:
    - name: /tmp/php-5.5.25.tar.gz
    - unless: test -e /tmp/php-5.5.25.tar.gz
    - source: salt://php_5_5_25/php-5.5.25.tar.gz

php_tar:
  cmd.run:
    - cwd: /tmp
    - names:
      - tar -zxvf /tmp/php-5.5.25.tar.gz
    - require:
#     - cmd: php_devel
      - file: php_source


redis_source:
  file.managed:
    - name: /tmp/redis-2.2.4.tgz
    - unless: test -e /tmp/redis-2.2.4.tgz
    - source: salt://php_5_5_25/redis-2.2.4.tgz




memcache_source:
  file.managed:
    - name: /tmp/memcache-2.2.7.tgz
    - unless: test -e /tmp/memcache-2.2.7.tgz
    - source: salt://php_5_5_25/memcache-2.2.7.tgz

sqlite_source:
  file.managed:
    - name: /tmp/sqlite.zip
    - unless: test -e /tmp/sqlite.zip
    - source: salt://php_5_5_25/sqlite.zip


php5.5_install_sh:
  file.managed:
    - name: /tmp/php_install_sh
    - unless: test -e /tmp/php_install_sh 
    - source: salt://php_5_5_25/php5.5_install.sh
    - user: root
    - group: root
    - mode: 755


compile_and_install:
  cmd.script:
    - source: salt://php_5_5_25/php5.5_install.sh
    - user: root
    - group: root
    - shell: /bin/bash
    - require:
      - file: php5.5_install_sh
      - file: php_source
      - file: sqlite_source
      - file: memcache_source
      - file: redis_source 
