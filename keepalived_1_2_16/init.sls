keepalived_devel:
  pkg.installed:
    - pkgs: [gcc,gcc-c++,cmake,libnl*,libpopt*,popt-static,openssl-devel,ncurses-devel,bison,libaio-devel,ipvsadm] 

keepalived_source:
  file.managed:
    - name: /tmp/keepalived-1.2.16.tar.gz
    - unless: test -e /tmp/keepalived-1.2.16.tar.gz
    - source: salt://keepalived_1_2_16/keepalived-1.2.16.tar.gz

keepalived_tar:
  cmd.run:
    - cwd: /tmp
    - names:
      - tar zxf /tmp/keepalived-1.2.16.tar.gz
    - require:
      - pkg: keepalived_devel
      - file: keepalived_source

keepalived_install:
  cmd.run:
    - names:
      - cd /tmp/keepalived-1.2.16 && ./configure --prefix=/usr/local/keepalived && make && make install
    - require:
      - cmd: keepalived_tar


