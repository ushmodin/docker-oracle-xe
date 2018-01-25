#!/bin/bash

rm /u01/app/oracle/product
ln -s /u01/app/oracle-product /u01/app/oracle/product

if [ -d "/u01/app/oracle/oradata" ]; then
    echo "XE:/u01/app/oracle/product/11.2.0/xe:N" >> /etc/oratab
    printf "ORACLE_DBENABLED=false\nLISTENER_PORT=1521\nHTTP_PORT=8080\nCONFIGURE_RUN=true\n" > /etc/default/oracle-xe
    chown oracle:dba /etc/oratab
    chown 664 /etc/oratab
    rm -rf /u01/app/oracle-product/11.2.0/xe/dbs
    rm -rf /u01/app/oracle-product/11.2.0/xe/network
    ln -s /u01/app/oracle/dbs /u01/app/oracle-product/11.2.0/xe/
    ln -s /u01/app/oracle/network /u01/app/oracle-product/11.2.0/xe/
    sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
    sed -i -E "s/PORT = [^)]+/PORT = 1521/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
    sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora
    service oracle-xe start
else
    /etc/init.d/oracle-xe configure responseFile=/xe.rsp
    mv /u01/app/oracle-product/11.2.0/xe/dbs /u01/app/oracle/
    mv /u01/app/oracle-product/11.2.0/xe/network /u01/app/oracle/
    ln -s /u01/app/oracle/dbs /u01/app/oracle-product/11.2.0/xe/
    ln -s /u01/app/oracle/network /u01/app/oracle-product/11.2.0/xe/
    chown -R oracle:dba /u01/app/oracle/*
fi

while true; do 
    sleep 60
done

service oracle-xe stop
