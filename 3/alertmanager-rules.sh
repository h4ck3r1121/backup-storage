sudo cat << EOF > /etc/prometheus/alertmanager-rules.yml
groups:

- name: Alertmanager rules

  rules:

    - alert: PrometheusJobMissing
      expr: 'absent(up{job="prometheus"})'
      for: 0m
      labels:
        severity: warning
      annotations:
        summary: Prometheus job missing (instance {{ $labels.instance }})
        description: "A Prometheus job has disappeared\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: PrometheusTargetMissing
      expr: 'up == 0'
      for: 0m
      labels:
        severity: critical
      annotations:
        summary: Prometheus target missing (instance {{ $labels.instance }})
        description: "A Prometheus target has disappeared. An exporter might be crashed.\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostOutOfMemory
      expr: '(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 10) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: Host out of memory (instance {{ $labels.instance }})
        description: "Node memory is filling up (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostUnusualNetworkThroughputIn
      expr: '(sum by (instance) (rate(node_network_receive_bytes_total[2m])) / 1024 / 1024 > 100) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: Host unusual network throughput in (instance {{ $labels.instance }})
        description: "Host network interfaces are probably receiving too much data (> 100 MB/s)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostUnusualNetworkThroughputOut
      expr: '(sum by (instance) (rate(node_network_transmit_bytes_total[2m])) / 1024 / 1024 > 100) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: Host unusual network throughput out (instance {{ $labels.instance }})
        description: "Host network interfaces are probably sending too much data (> 100 MB/s)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostUnusualDiskReadRate
      expr: '(sum by (instance) (rate(node_disk_read_bytes_total[2m])) / 1024 / 1024 > 50) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: Host unusual disk read rate (instance {{ $labels.instance }})
        description: "Disk is probably reading too much data (> 50 MB/s)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostOutOfInodes
      expr: '(node_filesystem_files_free{fstype!="msdosfs"} / node_filesystem_files{fstype!="msdosfs"} * 100 < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: Host out of inodes (instance {{ $labels.instance }})
        description: "Disk is almost running out of available inodes (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostHighCpuLoad
      expr: '(sum by (instance) (avg by (mode, instance) (rate(node_cpu_seconds_total{mode!="idle"}[2m]))) > 0.8) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 10m
      labels:
        severity: warning
      annotations:
        summary: Host high CPU load (instance {{ $labels.instance }})
        description: "CPU load is > 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: HostPhysicalComponentTooHot
      expr: '((node_hwmon_temp_celsius * ignoring(label) group_left(instance, job, node, sensor) node_hwmon_sensor_label{label!="tctl"} > 75)) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: Host physical component too hot (instance {{ $labels.instance }})
        description: "Physical hardware component too hot\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: SmartDeviceTemperatureWarning
      expr: 'smartctl_device_temperature > 60'
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: Smart device temperature warning (instance {{ $labels.instance }})
        description: "Device temperature  warning (instance {{ $labels.instance }})\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: SmartCriticalWarning
      expr: 'smartctl_device_critical_warning > 0'
      for: 15m
      labels:
        severity: critical
      annotations:
        summary: Smart critical warning (instance {{ $labels.instance }})
        description: "device has critical warning (instance {{ $labels.instance }})\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

    - alert: SmartMediaErrors
      expr: 'smartctl_device_media_errors > 0'
      for: 15m
      labels:
        severity: critical
      annotations:
        summary: Smart media errors (instance {{ $labels.instance }})
        description: "device has media errors (instance {{ $labels.instance }})\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"

# Please add ignored mountpoints in node_exporter parameters like
# "./prometheus-node-exporter --collector.filesystem.ignored-mount-points=^/(sys|proc|dev|run)($|/)".
# Same rule using "node_filesystem_free_bytes" will fire when disk fills for non-root users.
    - alert: HostOutOfDiskSpace
      expr: '((node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}'
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: Host out of disk space (instance {{ $labels.instance }})
        description: "Disk is almost full (< 10% left)\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
EOF
