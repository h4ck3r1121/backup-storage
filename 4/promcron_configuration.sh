#!/bin/bash

ip_address=''
port=''
path_system_backup=''

read -p "Введите ваш внешний ip-адрес, чтобы сервер получал значения или введите 'localhost' для локального мониторинга: " ip_address

read -p "Введите порт, по которому будет происходить обмен данными (порт не должен быть одинаков с Prometheus, Alertmanager и др.): " port

read -p "Введите путь для резервного копирования системы: " path_system_backup

cd /etc

sudo touch promcron

#full_command=system-backup 0 12 * * 6 sudo mksquashfs $path_system_backup/SystemBackup_$(date +'%d.%m.%g_%T').sqsh -no-duplicates -ef SystemBackup_$(date +'%d.%m.%g_%T').sqsh

sudo echo "system-backup 0 12 * * 6 sudo mksquashfs $path_system_backup/SystemBackup_$(date +'%d.%m.%g_%T').sqsh -no-duplicates -ef SystemBackup_$(date +'%d.%m.%g_%T').sqsh" >> /etc/promcron

if [ -d "~/.config/systemd/user" ]
then
	cd ~/.config/systemd/user
	sudo touch promcron.service
	sudo cat << EOF >> promcron.service
[Unit]
Description=Promcron service
Requires=prometheus.service

[Service]
Type=simple
User=prometheus
ExecStart=/usr/bin/promcron -prometheus-metrics $ip_address:$port -f /etc/promcron
Restart=always

[Install]
WantedBy=multi-user.target
EOF
else
	cd /usr/lib/systemd/system
	sudo touch promcron.service
        sudo cat << EOF >> promcron.service
[Unit]
Description=Promcron service
Requires=prometheus.service

[Service]
Type=simple
User=prometheus
ExecStart=/usr/bin/promcron -prometheus-metrics $ip_address:$port -f /etc/promcron
Restart=always

[Install]
WantedBy=multi-user.target
EOF
fi

sudo systemctl daemon-reload
sudo systemctl enable promcron.service

cd /etc/prometheus
sudo cat << EOF >> prometheus.yml
  - job_name: Promcron
    static_configs:
      - targets: ['$ip_address:$port']
EOF

sudo systemctl restart prometheus.service
sudo systemctl start promcron.service
