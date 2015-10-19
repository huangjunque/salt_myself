libaio:
  pkg:
    - installed

mysql_server:
  file.managed:
    - name: /tmp/MySQL-server-5.5.43-1.el6.x86_64.rpm
    - unless: test -e /tmp/MySQL-server-5.5.43-1.el6.x86_64.rpm
    - source: salt://mysql_5_5_43/MySQL-server-5.5.43-1.el6.x86_64.rpm

mysql_client:
  file.managed:
    - name: /tmp/MySQL-client-5.5.43-1.el6.x86_64.rpm
    - unless: test -e /tmp/MySQL-client-5.5.43-1.el6.x86_64.rpm
    - source: salt://mysql_5_5_43/MySQL-client-5.5.43-1.el6.x86_64.rpm

mysql_devel:
  file.managed:
    - name: /tmp/MySQL-devel-5.5.43-1.el6.x86_64.rpm
    - unless: test -e /tmp/MySQL-devel-5.5.43-1.el6.x86_64.rpm
    - source: salt://mysql_5_5_43/MySQL-devel-5.5.43-1.el6.x86_64.rpm

mysql_remove:
  cmd.run:
    - names:
      - yum remove -y mysql-libs
      - yum remove -y mysql-devel
      - yum remove -y mysql-client
      - yum remove -y mysql-server
      - yum remove -y mysql
      - yum remove -y MySQL-devel
      - yum remove -y MySQL-server
      - yum remove -y MySQL-client

mysql_server_install:
  cmd.run:
    - names:
      - rpm -ivh /tmp/MySQL-server-5.5.43-1.el6.x86_64.rpm
    - require:
      - file: mysql_server
      - cmd: mysql_remove

mysql_client_install:
  cmd.run:
    - names:
      - rpm -ivh /tmp/MySQL-client-5.5.43-1.el6.x86_64.rpm
    - require:
      - file: mysql_client
      - cmd: mysql_server_install

mysql_devel_install:
  cmd.run:
    - names:
      - rpm -ivh /tmp/MySQL-devel-5.5.43-1.el6.x86_64.rpm
    - require:
      - file: mysql_devel
      - cmd: mysql_client_install

mysql_conf:
  cmd.run:
    - name: cp -f /usr/share/mysql/my-huge.cnf /etc/my.cnf
    - require:
      - cmd: mysql_devel_install

mysql_start:
  cmd.run:
    - name: service mysql restart
    - require:
      - cmd: mysql_conf
