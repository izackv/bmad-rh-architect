# Task: rh-create-config

## Purpose

Create configuration files for Red Hat products following official
documentation and best practices.

## Supported Products

| Product | Config Types |
|---------|-------------|
| **RHEL** | sysctl, systemd, network, security |
| **OpenShift** | cluster config, OAuth, networking |
| **Ansible/AAP** | ansible.cfg, tower settings |
| **Keycloak/RHBK** | realm config, clients, users |
| **Satellite** | settings, content views |
| **IdM** | ipa config, DNS, certificates |

## Workflow

### Step 1: Identify Requirements

Ask user:
1. **Which product?**
   - Red Hat product name
   - Version (important for config syntax)

2. **What to configure?**
   - Specific feature or component
   - Current state (new install vs modification)

3. **Environment context**
   - Deployment type (standalone, HA, cluster)
   - Integration requirements
   - Security/compliance requirements

4. **Specific values**
   - Required settings
   - Constraints or limitations

### Step 2: Research Configuration

For the requested configuration:
- Identify official documentation
- Note version-specific syntax
- Identify required vs optional settings
- Note security implications

### Step 3: Generate Configuration

Create configuration with:
- Clear section organization
- Explanatory comments
- Secure defaults
- Environment variables for secrets

**Example RHEL sysctl config:**
```ini
# /etc/sysctl.d/99-custom.conf
# Purpose: [description]
# Documentation: [link]

# Network performance tuning
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

# Security hardening
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
```

**Example OpenShift config:**
```yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
    - name: ldap
      type: LDAP
      ldap:
        url: "ldap://ldap.example.com/ou=users,dc=example,dc=com?uid"
        insecure: false
        ca:
          name: ldap-ca-config
        bindDN: "cn=admin,dc=example,dc=com"
        bindPassword:
          name: ldap-bind-password
```

**Example Keycloak realm config:**
```json
{
  "realm": "example-realm",
  "enabled": true,
  "sslRequired": "external",
  "registrationAllowed": false,
  "loginWithEmailAllowed": true,
  "duplicateEmailsAllowed": false,
  "resetPasswordAllowed": true,
  "editUsernameAllowed": false,
  "bruteForceProtected": true
}
```

### Step 4: Validation Instructions

Provide:
- Syntax validation commands
- Test procedures
- Rollback instructions

### Step 5: Application Instructions

Document:
- Where to place the config file
- How to apply/reload
- Service restarts required
- Verification steps

## Output Format

```markdown
# Configuration: [Description]

## Purpose
[What this configuration does]

## Prerequisites
[Requirements before applying]

## Configuration File

**Path**: `/path/to/config/file`

\`\`\`[format]
[configuration content]
\`\`\`

## Application Steps

1. [Step to apply configuration]
2. [Verification step]

## Rollback

[How to revert if needed]

## References
- [Official documentation link]
```

## Product-Specific Guidelines

### RHEL
- Use drop-in directories when available
- Follow file naming conventions (e.g., nn-name.conf)
- Consider SELinux contexts

### OpenShift
- Use proper API versions
- Include metadata (name, namespace, labels)
- Reference secrets, not inline credentials

### Ansible/AAP
- Document all variables
- Use environment-specific overrides
- Secure credential handling

### Keycloak
- Export/import JSON format
- Separate realm from client configs
- Use client scopes appropriately

## Interaction Guidelines

- Verify product version before generating
- Explain configuration options
- Warn about security implications
- Provide complete, working configs
- Include validation steps
