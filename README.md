# rh-architect – Red Hat IT Architect expansion for BMAD

This repository contains an **expansion pack** for [BMAD-METHOD](https://github.com/bmad-code/bmad-method)
that adds a Red Hat–focused IT Architect persona and all the supporting
workflows you need to produce architecture documentation:

- `rh-it-architect` agent (IT Architect for RHEL / OpenShift / Ansible / RHBK)
- HLD / LLD templates
- Cost & timeline/resource estimation templates
- Project plan template
- Tasks and workflows for end-to-end architecture delivery

> **Note:** This pack assumes that BMAD core is already installed in your
> project from your organisation's **private BMAD repository**.

---

## Repository location

Intended GitHub location:

- `https://github.com/izackv/bmad-rh-architect`

You can change the name or description as you wish; the pack itself is
self-contained via `config.yaml`.

---

## Prerequisites

1. A **BMAD-enabled project**

   Your project must already have BMAD core installed – for example,
   using your internal instructions such as:

   ```bash
   npx bmad-method install
   ```

   or any other private setup your organisation uses.

2. **Python 3**

   Required in order to install and run `bmad-pack-installer` from PyPI.

---

## Installation

### 1. Download or clone this repository

Clone:

```bash
git clone https://github.com/izackv/bmad-rh-architect.git
cd bmad-rh-architect
```

Or download a release tarball/zip from GitHub and extract it, then:

```bash
cd bmad-rh-architect-<version>
```

### 2. Install `bmad-pack-installer` (if needed)

If you don't have it already:

```bash
python3 -m pip install --user bmad-pack-installer
```

Make sure `~/.local/bin` is in your `PATH` if you used `--user`, for example:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 3. Deploy this pack into your BMAD project

From inside the `bmad-rh-architect` folder, run:

```bash
./install.sh /path/to/your-bmad-project
```

What this does:

- Validates the target directory exists and looks like a BMAD project.
- Ensures `bmad-pack-installer` is available.
- Runs:

  ```bash
  bmad-pack-installer deploy . /path/to/your-bmad-project
  ```

- Registers this expansion pack with BMAD so that the `rh-it-architect`
  agent, tasks, templates and workflows are available in that project.

---

## Full Installation Example

Here's a complete example showing how to set up BMAD and install this pack
into a new project from scratch:

### Step 1: Install BMAD core into a new project

```bash
# Create a new project directory
mkdir -p ~/Data/projects/arch/rh-test01
folder_full_name=$(ls -d $_)
echo $folder_full_name

# Install BMAD core
npx bmad-method install
```

When prompted:
- **Target directory:** `/Users/[your-user]/Data/projects/arch/rh-test01`
- **Core type:** Choose `core`
- **Other options:** Accept all defaults
- **IDE:** Choose `Cursor` 

### Step 2: Install the bmad-rh-architect pack

```bash
# Clone this pack into a temporary directory
mkdir temp && cd "$_"
git clone https://github.com/izackv/bmad-rh-architect.git
cd bmad-rh-architect

# Install the pack installer tool
python3 -m pip install --user bmad-pack-installer

# Deploy the pack into your BMAD project
./install.sh ~/Data/projects/arch/rh-test01
```

After these steps, you can open your project directory (`~/Data/projects/arch/rh-test01`)
in your IDE and start using the `/rhArch` commands.

---

## Usage

Once the pack is deployed into your BMAD-enabled project, open that project
in your favourite BMAD-compatible environment (e.g. Cursor / Claude Code
workspace configured with BMAD).

Then you can use the new agent with slash commands, for example:

```text
/rhArch help
```

Common flows:

```text
/rhArch discovery
/rhArch create-hld
/rhArch create-lld
/rhArch estimate-costs
/rhArch estimate-timeline
/rhArch project-plan
/rhArch full-package
```

Behind the scenes these commands map to:

- The `rh-it-architect` agent in `agents/rh-it-architect.md`
- Tasks in `tasks/` (e.g. `rh-discovery-session.md`, `rh-create-hld.md`, ...)
- Templates in `templates/` for HLD/LLD/cost/timeline/plan
- Workflows in `workflows/` for new-solution and review/sign-off flows

---

## Customisation

Since this pack is just files under MIT license, you can:

- Fork the repository and change the persona language.
- Adapt templates (for example to match your company's document format).
- Add more tasks or workflows for your own processes.
- Version the pack and consume specific tags in different BMAD projects.

If you fork and modify, it's recommended to:

- Keep the `config.yaml` name unique (e.g. `mycompany-bmad-rh-architect`).
- Document your own install steps in the fork's README.

---

## License and Trademarks

This repository is licensed under the **MIT License** (see `LICENSE`).

- BMAD™ and BMAD-METHOD™ are trademarks of **BMad Code, LLC**.
- This pack is **not an official BMAD product**; it's an independent
  expansion pack built on top of the BMAD framework.
- Red Hat and related marks are trademarks or registered trademarks of
  Red Hat, Inc. or its subsidiaries.
