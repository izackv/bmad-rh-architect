# Task: rh-analyze-sosreport

## Purpose

Perform comprehensive analysis of sos-report output to identify system issues,
misconfigurations, resource constraints, and potential problems.

## Prerequisites

- Current directory contains extracted sos-report, OR
- User provides path to sos-report directory/archive

## Analysis Workflow

### Step 1: Validate sos-report Structure

Check for expected directories:
- `sos_commands/` - Command outputs
- `var/log/` - Log files
- `etc/` - Configuration snapshots
- `proc/` - Process information
- `sys/` - System information

If archive (.tar.xz), offer to guide extraction.

### Step 2: System Overview

Extract and summarize:
- **Hostname and OS**: `etc/redhat-release`, `sos_commands/host/hostname`
- **Hardware**: `proc/cpuinfo`, `proc/meminfo`, `sos_commands/hardware/`
- **Uptime and Load**: `proc/uptime`, `proc/loadavg`
- **Kernel**: `proc/version`, `sos_commands/kernel/`

### Step 3: Resource Analysis

Check for resource constraints:

| Resource | Files to Check | Warning Indicators |
|----------|----------------|-------------------|
| Memory | `proc/meminfo`, `sos_commands/memory/` | Low available, high swap usage |
| CPU | `proc/loadavg`, `sos_commands/processor/` | Load > CPU count |
| Disk | `sos_commands/filesys/df_*` | > 80% usage, inode exhaustion |
| Network | `sos_commands/networking/` | Errors, drops, high latency |

### Step 4: Service Health

Analyze service status:
- `sos_commands/systemd/systemctl_*` - Failed units
- `var/log/messages` or `var/log/journal/` - Error patterns
- `sos_commands/services/` - Service-specific issues

### Step 5: Security Review

Check security posture:
- SELinux: `sos_commands/selinux/`, `var/log/audit/`
- Firewall: `sos_commands/firewalld/` or `sos_commands/iptables/`
- Authentication: `etc/pam.d/`, `etc/sssd/`
- Certificates: Check for expiration warnings in logs

### Step 6: Error Pattern Detection

Search for common error patterns in logs:
- `var/log/messages` - System errors
- `var/log/secure` - Authentication failures
- `var/log/audit/audit.log` - SELinux denials
- Application-specific logs as relevant

### Step 7: OpenShift/Kubernetes Analysis (if applicable)

If cluster node detected:
- `sos_commands/openshift/` or `sos_commands/kubernetes/`
- Node status and conditions
- Pod failures and evictions
- Operator status

## Output Format

Produce a structured analysis report:

```markdown
# sos-report Analysis: [hostname]

## Executive Summary
[2-3 sentence overview of findings]

## System Information
- Hostname:
- OS:
- Kernel:
- Uptime:

## Critical Issues
[List issues requiring immediate attention]

## Warnings
[List issues that should be addressed]

## Resource Status
| Resource | Status | Details |
|----------|--------|---------|
| Memory   | OK/WARN/CRIT | ... |
| CPU      | OK/WARN/CRIT | ... |
| Disk     | OK/WARN/CRIT | ... |
| Network  | OK/WARN/CRIT | ... |

## Service Health
[Failed or degraded services]

## Security Findings
[SELinux, firewall, auth issues]

## Recommendations
[Prioritized action items]

## Next Steps
[Suggested follow-up commands or analysis]
```

## Interaction Guidelines

- Ask user what specific issue they're investigating (if any)
- Prioritize analysis based on user's concern
- Explain findings in context of the specific problem
- Offer to deep-dive into specific areas on request
