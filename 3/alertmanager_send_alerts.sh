sudo cat << EOF > /etc/prometheus/alertmanager.yml
global:
  smtp_require_tls: false
route:
  group_by: ['alertname']
  group_wait: 5s
  group_interval: 30m
  repeat_interval: 30m
  receiver: 'email'
receivers:
- name: 'email'
  email_configs:
  - to: 'your@email.com'
    from: 'your@email.com'
    smarthost: 'smtp.host.ru:465'
    auth_username: 'your@email.com'
    auth_identity: 'your@email.com'
    auth_password: 'password'
EOF
