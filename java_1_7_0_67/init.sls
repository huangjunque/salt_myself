jdk-file:
 file.managed:
   - source: salt://java_1_7_0_67/jdk-7u67-linux-x64.tar.gz
   - name: /tmp/jdk-7u67-linux-x64.tar.gz
   - unless: test -e /tmp/jdk-7u67-linux-x64.tar.gz

jdk-install:
 cmd.run:
   - cwd: /tmp
   - names: 
     - tar -xf jdk-7u67-linux-x64.tar.gz -C /usr/local/
     - cp /usr/bin/java{,.old} 
     - ln -sf /usr/local/jdk1.7.0_67/bin/java /usr/bin/java
   - onlyif: test -f /usr/bin/java
   - require:
     - file: jdk-file

jdk_install:
  cmd.run:
    - cwd: /tmp
    - names:
      - tar -xf jdk-7u67-linux-x64.tar.gz -C /usr/local/
      - ln -sf /usr/local/jdk1.7.0_67/bin/java /usr/bin/java
    - require:
      - file: jdk-file

jdk_vars:
  file.append:
    - name: /etc/profile
    - text: 
      - export JAVA_HOME=/usr/local/jdk1.7.0_67
      - export JRE_HOME=${JAVA_HOME}/jre
      - PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
      - CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
      - export JAVA_HOME JRE_HOME PATH CLASSPATH
  cmd.run:
    - name: source /etc/profile

jdk_chown:
  cmd.run:
    - names:
      - chown -R root:root /usr/local/jdk1.7.0_67
    - require:
      - cmd: jdk_install
 
