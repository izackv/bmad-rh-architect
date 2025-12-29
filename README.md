# rh-architect – Red Hat IT Architecture Expansion for BMAD

An expansion pack for [BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) that adds Red Hat-focused personas for architecture, support, and DevOps automation.

## What's Included

### Agents (Personas)

| Agent | Role | Expertise |
|-------|------|-----------|
| **rh-it-architect** | Lead IT Architect | Solution design, HLD/LLD, cost & timeline estimation |
| **rh-support** | Senior Support Engineer | Troubleshooting, sos-report analysis, diagnostics |
| **rh-devops** | Senior DevOps Engineer | Ansible, K8s manifests, Grafana dashboards, CI/CD |

### Templates & Workflows

- HLD / LLD architecture templates
- Cost and timeline estimation templates
- Project plan template
- Diagnostic and discovery report templates
- Ansible playbook, Grafana dashboard, K8s manifest templates
- End-to-end architecture delivery workflows

## Prerequisites

- **BMAD** installed in your target project
- **Python 3** installed on your system

## Installation

```bash
# 1. Clone this repository
git clone https://github.com/izackv/bmad-rh-architect.git
cd bmad-rh-architect

# 2. Run the installer (handles everything automatically)
./install.sh /path/to/your-bmad-project
```

The installer will:
- Verify BMAD is installed in the target directory
- Install `bmad-pack-installer` if needed
- Deploy the expansion pack
- Configure both Claude Code and Cursor IDE support

## Usage

### RH IT Architect

Lead architect for Red Hat solution design and documentation.

```
*help              - Show available commands
*discovery         - Run structured requirements gathering
*create-hld        - Create High-Level Design document
*create-lld        - Create Low-Level Design document
*estimate-costs    - Prepare cost estimates and BOM
*estimate-timeline - Estimate effort and resources
*project-plan      - Create implementation project plan
*full-package      - Generate complete architecture package
```

### RH Support Engineer

Expert troubleshooter with sos-report analysis capabilities.

```
*help                 - Show available commands
*analyze-sosreport    - Comprehensive sos-report analysis
*analyze-issue        - Analyze specific issues or errors
*search-docs          - Search Red Hat official documentation
*diagnose             - Run diagnostic health checks
*troubleshoot         - Guided troubleshooting session
*discover-environment - Discover environment from sos-report
```

**Auto-detection:** When activated in a sos-report directory, the agent automatically detects and offers analysis.

### RH DevOps Engineer

Automation expert for configuration and infrastructure as code.

```
*help                  - Show available commands
*create-playbook       - Create Ansible playbooks
*create-config         - Create configuration files for RH products
*create-dashboard      - Create Grafana dashboards
*create-manifest       - Create Kubernetes/OpenShift manifests
*create-pipeline       - Create CI/CD pipelines (Tekton, Jenkins, GitHub Actions)
*create-operator-config - Create Operator configurations
```

### Cursor IDE

Type `@rh-it-architect`, `@rh-support`, or `@rh-devops` in chat (Ctrl+L / Cmd+L) and select the `.mdc` file from autocomplete.

**Tip:** Add to your Cursor settings for better `.mdc` file editing:
```json
"workbench.editorAssociations": { "*.mdc": "default" }
```

## Full Example: New Project Setup

```bash
# Create and enter project directory
mkdir -p ~/projects/my-arch-project
cd ~/projects/my-arch-project

# Install BMAD core (select Cursor or Claude Code when prompted)
# When prompted for target directory, copy the output of pwd
pwd
npx bmad-method install

# Clone and install this expansion pack
cd /tmp
git clone https://github.com/izackv/bmad-rh-architect.git
cd bmad-rh-architect
./install.sh ~/projects/my-arch-project
```

## Pack Structure

```
bmad-rh-architect/
├── agents/              # Agent definitions
│   ├── rh-it-architect.md
│   ├── rh-support.md
│   └── rh-devops.md
├── agent-teams/         # Team configuration
├── tasks/               # Task definitions (19 tasks)
├── templates/           # Document templates (13 templates)
├── workflows/           # Architecture workflows
├── checklists/          # Quality assurance checklists
├── data/                # Reference data
├── config.yaml          # Pack configuration
└── install.sh           # One-command installer
```

## Red Hat Technology Coverage

| Category | Technologies |
|----------|-------------|
| **Infrastructure** | RHEL, Satellite, RHACM |
| **Container Platform** | OpenShift, Kubernetes, Podman, Quay |
| **Identity & Access** | RH SSO / RHBK (Keycloak), IdM, LDAP |
| **Automation** | Ansible, Ansible Automation Platform |
| **Monitoring** | Prometheus, Grafana |
| **CI/CD** | Tekton, OpenShift Pipelines, Jenkins |
| **Hybrid Cloud** | On-prem + AWS/Azure/GCP integration |

## Customization

Fork this repository and modify:
- Agent personas in `agents/`
- Document templates in `templates/`
- Task definitions in `tasks/`
- Workflows in `workflows/`

If you fork, update `config.yaml` with a unique pack name.

## License

MIT License. See [LICENSE](LICENSE).

**Trademarks:**
- BMAD™ and BMAD-METHOD™ are trademarks of BMad Code, LLC
- Red Hat and related marks are trademarks of Red Hat, Inc.
- This is an independent expansion pack, not an official BMAD product
