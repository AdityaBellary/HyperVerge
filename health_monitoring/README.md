## Health monitoring system

While thinking about designing a health monitoring system for any architecture, prometheus was one effective tool.
Prometheus is a monitoring system and time series database. It collects and stores metrics from configured targets at given intervals, evaluates rule expressions, displays the results.

To get the metrics we need to install node exporter on all our instances and to monitor any http endpoints we can use black box exporter which can be installed in our prometheus instance only.

The main high level design of the architecture is we will have a seperate instance where our prometheus will be running and based on the configuration we set, will scrape metrics and depending on the alerts we have set alertmanager will raise an incident to splunk which in the end will call the on-call user about the issue.

Things to be installed.
1. Node exporter on all the instances to be monitored.
2. prometheus on the monitoring server
3. black box exporter on the prometheus server
4. Grafana if needed to view dashboards on the prometheus server


Sample config files:-

promtheus job:
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  scrape_timeout: 10s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
  
  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Module name to use for probing.
    static_configs:
      - targets:
          - https://example.com    # Target URL to probe
          - http://example.org     # Another target URL
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: localhost:9115  # Blackbox Exporter address

rule_files:
  - "alert.rules.yml"

**----------------------------------------------------------**

Alert rule sample:-
groups:
  - name: example_alerts
    rules:
      - alert: HighCPUUsage
        expr: node_cpu_seconds_total{mode="idle"} < 20
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for more than 1 minute."

**----------------------------------------------------------**

Alertmanager sample:-
global:
  resolve_timeout: 5m

route:
  receiver: 'splunk-webhook'
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h

receivers:
  - name: infra
  victorops_configs:
    - api_key: api_key
      routing_key: route-path
      send_resolved: true
      entity_display_name: '{{ template "entitydisplayname" . }}'
      message_type: '{{ .CommonLabels.severity | toUpper }}'
      state_message: '{{ template "statemessage" . }}'
      custom_fields:
        hostname: '{{ .CommonLabels.name }}'
        HOSTADDRESS: '{{ .CommonLabels.privateip }}' 

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'instance']

**----------------------------------------------------------**