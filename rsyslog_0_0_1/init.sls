rsyslog_conf:
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://rsyslog_0_0_1/rsyslog.conf
    - user: root
    - mode: 644

rsyslog_restart:
  cmd.run:
    - names:
      - /etc/init.d/rsyslog restart
      - echo "update rsyslog_conf success!"
