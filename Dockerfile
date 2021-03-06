FROM ubuntu:trusty

COPY xe.rsp startup.sh oracle-xe_11.2.0-2_amd64.deb /
ENV TZ 'Asia/Krasnoyarsk'

RUN echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y libaio1 net-tools bc unixodbc unrar-free tzdata && \
    apt-get autoremove && \
    apt-get clean && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/awk /bin/awk && \
    mkdir /var/lock/subsys && \
    touch /var/lock/subsys/listener && \
    groupadd -g 521 dba && \
    useradd -u 521 -M -g dba -d /u01/app/oracle -s /bin/bash oracle && \
    dpkg -i /oracle-xe_11.2.0-2_amd64.deb && \
    mv /u01/app/oracle/product /u01/app/oracle-product && \
    rm /oracle-xe_11.2.0-2_amd64.deb && \
    echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

EXPOSE 1521
VOLUME /u01/app/oracle
CMD sh /startup.sh

