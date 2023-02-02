#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "[!] Please login the super user"
   exit 1
fi

ping -c 3 google.com.br > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "[!] Not found networking"
    exit 1
fi

echo "Plase insert port:"
read port
echo
echo "Please insert hostname"
read hostname
echo
echo
echo "Please insert group zabbix"
read group

sudo apt install zabbix-agent -y

cat << EOF > /lib/systemd/system/zabbix-agent.service
[Unit]
Description=Zabbix Agent
Documentation=man:zabbix_agentd
After=network.target

[Service]
Type=simple
User=zabbix
Group=zabbix
ExecStart=/usr/sbin/zabbix_agentd --foreground
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

cat << zbx > /etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogType=console
LogFileSize=0
Server=0.0.0.0/0
ListenPort=$port
ServerActive=yourIpZabbix:10051
HostMetadataItem=system.uname
HostMetadata=$group
Hostname=$hostname
RefreshActiveChecks=60
DebugLevel=3
Include=/etc/zabbix/zabbix_agentd.d/*.conf
zbx

sudo systemctl daemon-reload
sudo systemctl restart zabbix-agent.service

echo "Done"