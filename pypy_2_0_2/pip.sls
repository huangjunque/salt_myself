include:
  - pypy_2_0_2.install

pip_install:
  file.managed:
    - name: /tmp/get-pip.py
    - source: salt://pypy_2_0_2/get-pip.py
    - user: root
    - group: root
  cmd.run:
    - names:
      - pypy /tmp/get-pip.py 
      - ln -s /usr/lib64/pypy-2.0.2/bin/pip /usr/bin/pypy_pip
    - unless: test -f /usr/bin/pypy_pip
    - require:
      - file: pip_install
