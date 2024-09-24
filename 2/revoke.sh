#!/bin/bash

read -p "Введите уникальное имя пользователя на латинице, чтобы отозвать доступ: " unique_name

~/easy-rsa/easyrsa revoke $unique_name

~/easy-rsa/easyrsa gen-crl

sudo cp ~/easy-rsa/pki/crl.pem /etc/openvpn/server

sudo echo "crl-verify crl.pem" >> /etc/openvpn/server/server.conf

sudo systemctl restart openvpn-server@server.service
