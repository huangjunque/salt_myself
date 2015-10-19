/tmp:
  file.directory: []

python275_source:
  file.managed:
    - name: /tmp/Python-2.7.5.tgz
    - source: salt://python_2_7_5/Python-2.7.5.tgz

python275_pkgs:
  pkg.installed:
    - pkgs: [expat-devel,python-devel,python-virtualenv,zlib-devel,bzip2,bzip2-devel,readline-devel,sqlite,sqlite-devel,openssl-devel]  


python275_install:
  cmd.run:
    - cwd: /tmp
    - names: 
      - cd /tmp/ && tar zvxf /tmp/Python-2.7.5.tgz



python275_install_2:
  cmd.run:
    - cwd: /tmp
    - name: cd /tmp/Python-2.7.5 && ./configure --prefix=/usr/local  && make && make altinstall
    - require:
      - cmd: python275_install

python275_ln:
  cmd.run:
    - cwd: /tmp
    - name: ln -s /usr/local/bin/python2.7 /usr/local/bin/python
    - require:
      - cmd: python275_install_2



update_python_shebang:
  cmd.run:
    - unless: '[[ `cat /usr/bin/yum` =~ "/usr/bin/python2" ]]'
    - name: find /**/*bin -name "*" | xargs grep -l "/usr/bin/python" | xargs sed -i "s/#\!\/usr\/bin\/python\([^2]*\)$/#\!\/usr\/bin\/python2.6\1/"
  




