#!/bin/bash

wget https://www.pingdom.com/rss/probe_servers.xml --no-check-certificate

SERVERS=`cat probe_servers.xml | grep IP | awk -F: '{print $2}' | awk -F";" '{print $1}'`

for server in $SERVERS
do
   echo "/sbin/iptables -A RH-Firewall-1-INPUT -s $server -p tcp -m tcp --dport 25 -j ACCEPT"
done

rm -rf probe_servers.xml
