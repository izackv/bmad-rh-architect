# Task: rh-diagnose

## Purpose

Run systematic diagnostic checks to assess system or cluster health
and identify potential issues before they become critical.

## Diagnostic Scope

Select diagnostic scope based on context:

1. **Single System (RHEL)**
   - OS and kernel health
   - Resource utilization
   - Service status
   - Security posture

2. **OpenShift/Kubernetes Cluster**
   - Cluster health
   - Node status
   - Control plane components
   - Workload health

3. **Ansible/AAP**
   - Controller health
   - Execution environment status
   - Job execution metrics

## Diagnostic Workflow

### Step 1: Determine Scope

Ask user:
- What system(s) to diagnose?
- Access method (local, SSH, sos-report, API)
- Any specific concerns to prioritize?

### Step 2: System Diagnostics (RHEL)

#### 2.1 OS Health
```bash
# System info
cat /etc/redhat-release
uname -r
uptime

# Boot issues
systemctl is-system-running
journalctl -p err -b
```

#### 2.2 Resource Health
```bash
# Memory
free -h
cat /proc/meminfo | grep -E 'MemTotal|MemAvailable|SwapTotal|SwapFree'

# CPU
nproc
cat /proc/loadavg
top -bn1 | head -20

# Disk
df -h
df -i
lsblk

# Network
ip addr
ss -tuln
```

#### 2.3 Service Health
```bash
# Failed services
systemctl list-units --state=failed

# Critical services
systemctl status sshd chronyd rsyslog
```

#### 2.4 Security Health
```bash
# SELinux
getenforce
ausearch -m AVC -ts recent

# Firewall
firewall-cmd --state
firewall-cmd --list-all

# Updates
dnf check-update --security
```

### Step 3: Cluster Diagnostics (OpenShift)

#### 3.1 Cluster Health
```bash
oc get clusterversion
oc get clusteroperators
oc get nodes
```

#### 3.2 Node Health
```bash
oc describe nodes | grep -A5 Conditions
oc adm top nodes
```

#### 3.3 Workload Health
```bash
oc get pods -A | grep -v Running | grep -v Completed
oc get events -A --sort-by='.lastTimestamp' | tail -20
```

### Step 4: Analyze Results

For each check:
- **OK**: Healthy, no action needed
- **WARNING**: Degraded, should address soon
- **CRITICAL**: Requires immediate attention

### Step 5: Generate Report

Use template: `rh-diagnostic-report-template.yaml`

## Output Format

```markdown
# Diagnostic Report: [System/Cluster Name]

**Date**: [timestamp]
**Scope**: [RHEL/OpenShift/AAP]
**Overall Status**: [HEALTHY/WARNING/CRITICAL]

## Executive Summary
[2-3 sentence overview]

## System Information
| Property | Value |
|----------|-------|
| Hostname | ... |
| OS | ... |
| Kernel | ... |
| Uptime | ... |

## Health Status

### Resources
| Resource | Status | Value | Threshold |
|----------|--------|-------|-----------|
| Memory | OK/WARN/CRIT | 45% used | 80% |
| CPU | OK/WARN/CRIT | load 2.3 | < cores |
| Disk / | OK/WARN/CRIT | 65% used | 80% |
| Swap | OK/WARN/CRIT | 0% used | 20% |

### Services
| Service | Status | Notes |
|---------|--------|-------|
| sshd | running | OK |
| ... | ... | ... |

### Security
| Check | Status | Notes |
|-------|--------|-------|
| SELinux | Enforcing | OK |
| Firewall | Active | OK |
| Updates | 3 pending | Review |

## Issues Found

### Critical
[List critical issues]

### Warnings
[List warnings]

## Recommendations
[Prioritized action items]

## Commands Used
[List of diagnostic commands for reproducibility]
```

## Interaction Guidelines

- Explain what each check does before running
- Present results progressively
- Highlight issues as they're found
- Offer to deep-dive into specific areas
- Provide remediation suggestions for issues found
