#!/bin/bash

read -p "Введите имя сетевого интерфейса, который используется для интернета: " my_interface

read -p "Введите протокол, который используется в OpenVPN (TCP или UDP): " my_protocol

read -p "Введите номер порта, который используется для подключения к OpenVPN (по-умолчанию 1194): " my_port

sudo iptables -t nat -I POSTROUTING 1 -s 10.8.0.0/24 -o $my_interface -j MASQUERADE
sudo iptables -I INPUT 1 -i tun0 -j ACCEPT
sudo iptables -I FORWARD 1 -i $my_interface -o tun0 -j ACCEPT
sudo iptables -I FORWARD 1 -i tun0 -o $my_interface -j ACCEPT
sudo iptables -I INPUT 1 -i ens3 -p $my_protocol --dport $my_port -j ACCEPT

if [ $(lsb_release -d | grep -ioP 'ubuntu|mint' | wc -l) -ge 1 ]
then
	sudo iptables-save > /etc/iptables/rules.v4
else
	sudo iptables-save > /etc/sysconfig/iptables
fi

