# Task: rh-discover-environment

## Purpose

Discover and document the complete environment inventory from sos-report
data, creating a comprehensive picture of the system, cluster, or site.

## Discovery Scope

Based on sos-report contents, discover:

1. **Single System** - Detailed system inventory
2. **Cluster Node** - Node + cluster context
3. **Site/Fleet** - Multiple sos-reports for site view

## Discovery Workflow

### Step 1: Identify sos-report Type

Examine sos-report to determine:
- Standalone RHEL system
- OpenShift/Kubernetes node (control plane or worker)
- Satellite server
- Ansible controller
- Other specialized role

**Detection indicators:**
- `sos_commands/openshift/` → OpenShift node
- `sos_commands/satellite/` → Satellite server
- `sos_commands/ansible/` → Ansible system
- `etc/kubernetes/` → Kubernetes node

### Step 2: Hardware Discovery

Extract from sos-report:

```
proc/cpuinfo          → CPU model, cores, sockets
proc/meminfo          → Total memory
sos_commands/block/   → Storage devices
sos_commands/hardware/→ Hardware details
sos_commands/pci/     → PCI devices
sys/class/net/        → Network interfaces
```

**Output:**
| Component | Details |
|-----------|---------|
| CPU | [model, cores, sockets] |
| Memory | [total RAM] |
| Storage | [devices, sizes] |
| Network | [interfaces, speeds] |

### Step 3: OS Discovery

Extract:

```
etc/redhat-release    → OS version
proc/version          → Kernel version
etc/hostname          → Hostname
etc/machine-id        → Machine ID
sos_commands/date/    → Timezone
```

### Step 4: Network Discovery

Extract network configuration:

```
etc/sysconfig/network-scripts/  → Interface configs (legacy)
etc/NetworkManager/             → NM configurations
sos_commands/networking/        → IP addresses, routes, DNS
etc/hosts                       → Local DNS entries
etc/resolv.conf                 → DNS servers
```

**Output:**
| Interface | IP Address | Gateway | DNS |
|-----------|------------|---------|-----|
| eth0 | ... | ... | ... |

### Step 5: Package Discovery

Extract installed software:

```
sos_commands/rpm/               → Installed packages
sos_commands/dnf/ or yum/       → Repository config
```

Focus on:
- Red Hat product packages
- Version information
- Repository sources

### Step 6: Service Discovery

Extract running services:

```
sos_commands/systemd/           → Service status
sos_commands/services/          → Service details
```

**Categorize:**
- Core OS services
- Red Hat product services
- Third-party services
- Custom services

### Step 7: Storage Discovery

Extract storage layout:

```
sos_commands/filesys/           → Filesystem info
sos_commands/lvm2/              → LVM configuration
sos_commands/devicemapper/      → DM devices
etc/fstab                       → Mount configuration
```

### Step 8: Cluster Discovery (if applicable)

For OpenShift/Kubernetes nodes:

```
sos_commands/openshift/         → Cluster info
sos_commands/kubernetes/        → K8s resources
etc/kubernetes/                 → K8s configs
```

Extract:
- Cluster name and version
- Node role (control plane/worker)
- Node labels and taints
- Running pods summary

### Step 9: Security Discovery

Extract security configuration:

```
sos_commands/selinux/           → SELinux status
sos_commands/firewalld/         → Firewall rules
etc/ssh/                        → SSH configuration
etc/pam.d/                      → PAM configuration
etc/sssd/                       → SSSD configuration
```

### Step 10: Generate Inventory

Use template: `rh-environment-discovery-template.yaml`

## Output Format

```markdown
# Environment Discovery: [hostname]

**Discovery Date**: [timestamp]
**sos-report Date**: [from sos-report]
**System Type**: [RHEL/OpenShift Node/Satellite/etc.]

## Hardware Summary
| Component | Specification |
|-----------|---------------|
| Model | [hardware model] |
| CPU | [cores] x [model] |
| Memory | [total GB] |
| Storage | [total capacity] |

## Operating System
| Property | Value |
|----------|-------|
| OS | RHEL [version] |
| Kernel | [version] |
| Hostname | [name] |
| Architecture | [arch] |

## Network Configuration
### Interfaces
| Interface | IP Address | Type | Status |
|-----------|------------|------|--------|
| ... | ... | ... | ... |

### DNS
- Servers: [list]
- Search domains: [list]

### Routes
[Key routing information]

## Storage Configuration
### Filesystems
| Mount Point | Device | Type | Size | Used |
|-------------|--------|------|------|------|
| / | ... | ... | ... | ... |

### LVM (if applicable)
[VG/LV layout]

## Installed Red Hat Products
| Product | Version | Status |
|---------|---------|--------|
| RHEL | [version] | Active |
| ... | ... | ... |

## Running Services
### Red Hat Services
| Service | Status | Notes |
|---------|--------|-------|
| ... | ... | ... |

### System Services
[Core services status]

## Security Configuration
| Setting | Value |
|---------|-------|
| SELinux | [status] |
| Firewall | [status] |
| SSH | [config summary] |

## Cluster Context (if applicable)
| Property | Value |
|----------|-------|
| Cluster | [name] |
| Role | [control-plane/worker] |
| Version | [OCP version] |

## Diagram
[ASCII or Mermaid diagram if complex]

## Notes
[Any observations or anomalies]
```

## Interaction Guidelines

- Present discovery progressively
- Highlight interesting or unusual findings
- Offer to deep-dive into specific areas
- Note any missing or incomplete data
- Suggest related discovery (other sos-reports for site view)
