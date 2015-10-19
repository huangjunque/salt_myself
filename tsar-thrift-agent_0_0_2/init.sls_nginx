tsar_rpm:
  file.managed:
    - name: /tmp/tsaragent-2.1.4-1.x86_64.rpm
    - source: salt://tsar-thrift-agent_0_0_2/tsaragent-2.1.4-1.x86_64.rpm


pkill_tsar:
  cmd.run:
    - names:
      - pkill -f tsar 
      - rpm -e `rpm -qa | grep tsar`
      - cd /tmp ; rpm -ivh /tmp/tsaragent-2.1.4-1.x86_64.rpm
    - onlyif:
      - ps -ef | grep tsar
    - require:
      - file: tsar_rpm

tsarex_conf:
  cmd.run:
    - name: echo hostid=$(/sbin/ifconfig  | grep "inet addr" -m 1 | cut -d ":" -f 2 | awk -F " " '{print $1}') > /etc/tsar/tsarex.conf
    - require:
      - file: tsar_rpm

tsar_conf:
  file.managed:
    - name: /etc/tsar/tsar.conf
    - source: salt://tsar-thrift-agent_0_0_2/tsar.conf

tsarnginx_conf:
  file.managed:
    - name: /etc/tsar/tsarnginx.conf
    - source: salt://tsar-thrift-agent_0_0_2/tsarnginx.conf

tsar_start:
  cmd.run:
    - names: 
      - tsar -c 
      - tsar -t
      - ps -ef | grep tsar
    - require:
      - cmd: tsarex_conf
      - file: tsar_conf
      - file: tsarnginx_conf
