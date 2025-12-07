# rh-architect – Red Hat IT Architect Expansion for BMAD

An expansion pack for [BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) that adds a Red Hat-focused IT Architect persona with templates and workflows for architecture documentation.

## What's Included

- **rh-it-architect** agent (RHEL / OpenShift / Ansible / RHBK expertise)
- HLD / LLD templates
- Cost and timeline estimation templates
- Project plan template
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

### Claude Code

```
/rh-it-architect help
/rhArch discovery
/rhArch create-hld
/rhArch create-lld
/rhArch estimate-costs
/rhArch estimate-timeline
/rhArch project-plan
/rhArch full-package
```

### Cursor IDE

Type `@rh-it-architect` in chat (Ctrl+L / Cmd+L) and select the `.mdc` file from autocomplete.

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
├── agents/          # rh-it-architect agent definition
├── tasks/           # rh-discovery-session, rh-create-hld, etc.
├── templates/       # HLD, LLD, cost, timeline, project plan
├── workflows/       # new-solution, review/sign-off flows
├── checklists/      # Quality assurance checklists
└── install.sh       # One-command installer
```

## Customization

Fork this repository and modify:
- Agent persona and language in `agents/`
- Document templates in `templates/`
- Workflows in `workflows/`

If you fork, update `config.yaml` with a unique pack name.

## License

MIT License. See [LICENSE](LICENSE).

**Trademarks:**
- BMAD™ and BMAD-METHOD™ are trademarks of BMad Code, LLC
- Red Hat and related marks are trademarks of Red Hat, Inc.
- This is an independent expansion pack, not an official BMAD product