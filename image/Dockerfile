FROM zabbix/zabbix-server-pgsql:alpine-6.2-latest

USER root

RUN  apk --no-cache upgrade \
     && apk --no-cache add vim bash nmap git python3 \
     && python3 -m ensurepip --upgrade \
     && pip3 install --upgrade pip \
     && pip3 install httplib2 configparser \
     && echo nameserver 8.8.8.8 >> /etc/resolv.conf