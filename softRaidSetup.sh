#!/bin/bash
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm  
yum install -y nagios-plugins-linux_raid 
yum install -y nrpe
echo "command[check_linux_raid]=/usr/lib64/nagios/plugins/check_linux_raid" >> /etc/nagios/nrpe.cfg
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1,$IP/' /etc/nagios/nrpe.cfg
sed -i 's/Defaults    requiretty/#Defaults  requiretty/g' /etc/sudoers 
iptables -I INPUT -p tcp -m tcp --dport 5666 -j REJECT 
iptables -I INPUT -p tcp -m tcp -s $IP --dport 5666 -j ACCEPT
service iptables save
service nrpe start 
chkconfig nrpe on
