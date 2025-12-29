# Task: rh-create-dashboard

## Purpose

Create Grafana dashboards for monitoring Red Hat products with
meaningful visualizations, alerts, and drill-down capabilities.

## Dashboard Types

### Infrastructure Dashboards
- RHEL system metrics (CPU, memory, disk, network)
- Node overview and health
- Storage and filesystem monitoring

### OpenShift Dashboards
- Cluster overview
- Node metrics
- Namespace/workload metrics
- Pod and container metrics
- Operator status

### Application Dashboards
- Service metrics
- Custom application KPIs
- Business metrics

### Red Hat Product Dashboards
- Keycloak authentication metrics
- Ansible job execution
- Satellite sync status

## Workflow

### Step 1: Requirements Gathering

Ask user:
1. **What to monitor?**
   - System/service/application name
   - Red Hat product (if applicable)
   - Key metrics of interest

2. **Data source**
   - Prometheus (most common)
   - Elasticsearch
   - InfluxDB
   - Other

3. **Audience**
   - Operations team
   - Developers
   - Management
   - (affects detail level and layout)

4. **Alert requirements**
   - Critical thresholds
   - Warning thresholds
   - Notification channels

### Step 2: Design Dashboard

Plan dashboard layout:

**Structure:**
```
Row 1: Overview/Summary (single stats, gauges)
Row 2: Time series graphs (trends)
Row 3: Detailed metrics (tables, heatmaps)
Row 4: Logs/Events (if applicable)
```

**Standard elements:**
- Dashboard title and description
- Variable selectors (host, namespace, timerange)
- Refresh interval selector
- Consistent color scheme

### Step 3: Generate Dashboard JSON

Create Grafana dashboard JSON:

```json
{
  "dashboard": {
    "id": null,
    "uid": null,
    "title": "Dashboard Title",
    "description": "Dashboard description",
    "tags": ["red-hat", "product-name"],
    "timezone": "browser",
    "schemaVersion": 38,
    "version": 1,
    "refresh": "30s",
    "templating": {
      "list": [
        {
          "name": "datasource",
          "type": "datasource",
          "query": "prometheus"
        },
        {
          "name": "instance",
          "type": "query",
          "datasource": "${datasource}",
          "query": "label_values(up, instance)"
        }
      ]
    },
    "panels": [
      {
        "id": 1,
        "title": "Panel Title",
        "type": "stat",
        "gridPos": {"h": 4, "w": 6, "x": 0, "y": 0},
        "datasource": "${datasource}",
        "targets": [
          {
            "expr": "prometheus_query",
            "legendFormat": "{{label}}"
          }
        ],
        "fieldConfig": {
          "defaults": {
            "thresholds": {
              "mode": "absolute",
              "steps": [
                {"color": "green", "value": null},
                {"color": "yellow", "value": 80},
                {"color": "red", "value": 90}
              ]
            }
          }
        }
      }
    ]
  }
}
```

### Step 4: Common Panels by Product

#### RHEL System Metrics
```promql
# CPU Usage
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory Usage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Disk Usage
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100

# Network Traffic
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

#### OpenShift Metrics
```promql
# Cluster CPU
sum(rate(container_cpu_usage_seconds_total[5m]))

# Cluster Memory
sum(container_memory_working_set_bytes)

# Pod Count
count(kube_pod_info)

# Failed Pods
count(kube_pod_status_phase{phase="Failed"})
```

#### Keycloak Metrics
```promql
# Login Success Rate
rate(keycloak_logins_total{outcome="success"}[5m])

# Active Sessions
keycloak_sessions_count

# Failed Logins
rate(keycloak_login_errors_total[5m])
```

### Step 5: Add Alerts

Include alert rules:

```json
{
  "alert": {
    "alertRuleTags": {},
    "conditions": [
      {
        "evaluator": {"params": [90], "type": "gt"},
        "operator": {"type": "and"},
        "query": {"params": ["A", "5m", "now"]},
        "reducer": {"params": [], "type": "avg"},
        "type": "query"
      }
    ],
    "executionErrorState": "alerting",
    "for": "5m",
    "frequency": "1m",
    "handler": 1,
    "name": "Alert Name",
    "noDataState": "no_data",
    "notifications": []
  }
}
```

## Output Format

Provide:
1. Complete dashboard JSON
2. Import instructions
3. Required data sources
4. Variable configuration
5. Alert channel setup (if applicable)

## Interaction Guidelines

- Ask about existing dashboards to avoid duplication
- Confirm metric availability in data source
- Explain panel choices and thresholds
- Offer customization options
- Provide dashboard as downloadable JSON
