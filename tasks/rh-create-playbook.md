# Task: rh-create-playbook

## Purpose

Create Ansible playbooks for automating Red Hat product installation,
configuration, and operations following Ansible best practices.

## Playbook Types

### System Configuration
- RHEL initial setup and hardening
- Package management
- User and group management
- Service configuration
- Security configuration (SELinux, firewall)

### Application Deployment
- Application installation
- Configuration management
- Database setup
- Service orchestration

### OpenShift Operations
- Cluster configuration
- Workload deployment
- Operator installation
- Backup and restore

### Compliance & Security
- CIS benchmark hardening
- Security scanning
- Audit configuration
- Certificate management

## Workflow

### Step 1: Requirements Gathering

Ask user:
1. **What is the target?**
   - RHEL systems
   - OpenShift cluster
   - Ansible Automation Platform
   - Other Red Hat product

2. **What action to automate?**
   - Installation
   - Configuration
   - Update/patch
   - Backup/restore
   - Custom operation

3. **Environment details**
   - Target hosts/inventory
   - Required credentials/secrets
   - Network considerations
   - Existing automation to integrate with

4. **Special requirements**
   - Idempotency requirements
   - Error handling needs
   - Rollback capabilities
   - Compliance requirements

### Step 2: Design Playbook Structure

Determine structure based on scope:

**Simple task**: Single playbook file
```
playbook.yml
```

**Medium complexity**: Playbook with vars file
```
playbook.yml
vars/
  main.yml
```

**Complex automation**: Role-based structure
```
site.yml
roles/
  role_name/
    tasks/
    handlers/
    templates/
    vars/
    defaults/
    meta/
```

### Step 3: Generate Playbook

Create playbook following Ansible best practices:

```yaml
---
# Playbook: [descriptive name]
# Purpose: [what this playbook does]
# Author: RH DevOps Agent
# Date: [timestamp]
#
# Usage:
#   ansible-playbook playbook.yml -i inventory
#
# Variables:
#   - var_name: description (default: value)

- name: [Play description]
  hosts: "{{ target_hosts | default('all') }}"
  become: true
  gather_facts: true

  vars:
    # Configurable variables with sensible defaults
    variable_name: "default_value"

  pre_tasks:
    - name: Validate prerequisites
      ansible.builtin.assert:
        that:
          - ansible_os_family == "RedHat"
        fail_msg: "This playbook only supports Red Hat family systems"

  tasks:
    - name: Task description
      ansible.builtin.module_name:
        parameter: "{{ variable }}"
      register: result
      tags:
        - tag_name

    - name: Handle result
      ansible.builtin.debug:
        var: result
      when: result is changed

  handlers:
    - name: Restart service
      ansible.builtin.systemd:
        name: service_name
        state: restarted
        daemon_reload: true

  post_tasks:
    - name: Verify completion
      ansible.builtin.debug:
        msg: "Playbook completed successfully"
```

### Step 4: Best Practices Checklist

Verify playbook follows best practices:

- [ ] Uses fully qualified collection names (FQCN)
- [ ] All tasks have descriptive names
- [ ] Variables have sensible defaults
- [ ] Sensitive data uses vault or external secrets
- [ ] Tasks are idempotent
- [ ] Error handling is implemented
- [ ] Handlers are used for service restarts
- [ ] Tags are applied for selective execution
- [ ] Comments explain complex logic
- [ ] Molecule tests are included (if complex)

### Step 5: Generate Supporting Files

As needed, create:

**inventory.yml** (example)
```yaml
all:
  hosts:
    host1.example.com:
  children:
    group_name:
      hosts:
        host2.example.com:
```

**vars/main.yml** (variables file)
```yaml
---
# Variables for [playbook name]
variable_name: value
```

**requirements.yml** (dependencies)
```yaml
---
collections:
  - name: ansible.posix
  - name: community.general
```

## Output Format

Provide:
1. Main playbook file(s)
2. Variables file (if needed)
3. Inventory example
4. Usage instructions
5. Variable documentation

## Interaction Guidelines

- Ask clarifying questions before generating
- Explain design decisions
- Offer alternatives when appropriate
- Include comments in generated code
- Provide testing instructions
