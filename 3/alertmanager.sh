#!/bin/bash

#создаем папки для Alertmanager

sudo mkdir -p /etc/alertmanager
sudo mkdir -p /var/lib/alertmanager
sudo mkdir -p /etc/amtool

#копируем файлы alertmanager и конфигурационные файлы

sudo cp alertmanager /usr/local/bin/
sudo cp alertmanager.yml /etc/alertmanager
sudo cp amtool /usr/local/bin/

#меняем владельца папок и файлов по соображениям безопасности

sudo chown prometheus:prometheus /usr/local/bin/alertmanager
sudo chown -R prometheus:prometheus /etc/alertmanager
sudo chown prometheus:prometheus /var/lib/alertmanager

#автозапуск

sudo cat << EOF > /etc/systemd/system/alertmanager.service
[Unit]
Description=Prometheus Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/alertmanager \
  --config.file /etc/alertmanager/alertmanager.yml \
  --storage.path /var/lib/alertmanager/

[Install]
WantedBy=multi-user.target
EOF

