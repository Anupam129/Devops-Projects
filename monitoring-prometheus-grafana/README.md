🔹 Installation (Basic)


Prometheus on Linux:

# Download Prometheus


wget https://github.com/prometheus/prometheus/releases/download/v2.48.0/prometheus-2.48.0.linux-amd64.tar.gz
tar -xvzf prometheus-2.48.0.linux-amd64.tar.gz
cd prometheus-2.48.0.linux-amd64


# Run Prometheus

./prometheus --config.file=prometheus.yml
🔹 Example Prometheus Configuration (prometheus.yml)
global:
  scrape_interval: 15s  # How often to collect metrics

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']  # Prometheus scrapes itself

  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']  # Node Exporter metrics
Explanation:
•	Each “job” defines what to scrape.
•	Targets specify IP:port of exporters.
________________________________________
3. Exporters in Prometheus

   
Exporters are agents that expose metrics from your applications, servers, or databases.
Exporter	Purpose	Port
Node Exporter	Linux system metrics (CPU, RAM, disk, network)	9100
Blackbox Exporter	Check endpoint availability (ping, HTTP)	9115
MySQL Exporter	Database metrics	9104
Nginx Exporter	Web server metrics	9113
Example: Install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar -xzf node_exporter-1.7.0.linux-amd64.tar.gz
cd node_exporter-1.7.0.linux-amd64
./node_exporter &
Now, visit http://<server-ip>:9100/metrics → you’ll see system metrics.
Add this to prometheus.yml:
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
________________________________________

4. Alerting with Prometheus

   
Prometheus sends alerts when a condition is met — for example, CPU > 80% for 5 minutes.
Example Rule (alert.rules.yml)
groups:
- name: example_alerts
  rules:
  - alert: HighCPUUsage
    expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage detected on {{ $labels.instance }}"
      description: "CPU usage is above 80% for more than 5 minutes."
Include it in your Prometheus config:
rule_files:
  - "alert.rules.yml"
________________________________________
5. Alertmanager Setup

   
Prometheus sends alerts to Alertmanager, which then notifies users via Slack, Email, PagerDuty, etc.
Example configuration (alertmanager.yml):
route:
  receiver: 'email-alert'

receivers:
- name: 'email-alert'
  email_configs:
  - to: 'team@example.com'
    from: 'alert@example.com'
    smarthost: 'smtp.gmail.com:587'
    auth_username: 'alert@example.com'
    auth_password: 'your-app-password'
________________________________________

6. Grafana Dashboards

   
🔹 What is Grafana?
Grafana is an open-source visualization tool used to create dashboards from Prometheus metrics.
🔹 Setup Grafana
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-11.0.0.linux-amd64.tar.gz
tar -zxvf grafana-enterprise-11.0.0.linux-amd64.tar.gz
cd grafana-*
./bin/grafana-server web
Visit:
http://localhost:3000 (default user/pass: admin/admin)

________________________________________

🔹 Connect Grafana to Prometheus

1.	Go to Connections → Data Sources → Add Data Source
2.	Choose Prometheus
3.	URL = http://localhost:9090
4.	Save & Test ✅
________________________________________
🔹 Create Dashboards

Example queries using PromQL:
Metric	PromQL Query	Description
CPU Usage	100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)	Show CPU utilization
Memory Usage	(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100	Show RAM usage %
Disk Space	(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100	Disk utilization
HTTP Requests	rate(http_requests_total[5m])	Requests per second
You can visualize these using:
•	Gauge panels (for CPU, RAM)
•	Graph panels (for trends)
•	Table panels (for list of instances)
________________________________________
7. Example End-to-End Use Case
Imagine a DevOps engineer managing a web application with 3 EC2 instances and a MySQL database.
You can set up:
•	Node Exporter on EC2 → system metrics
•	MySQL Exporter → DB metrics
•	Prometheus → collects all metrics
•	Alertmanager → sends alerts to Slack/email
•	Grafana → dashboards for visualization
When CPU > 85%, an alert is triggered, team notified on Slack, and metrics visible in Grafana in real time.

