# Task: rh-discovery-session

## Purpose

Run a structured discovery session to collect all the information needed
for architecture work on a Red Hat–based solution.

## Inputs to collect

- Business domain, business goals and success criteria.
- Stakeholders and their roles.
- Current state (systems, platforms, pain points).
- High-level functional requirements.
- Non-functional requirements (NFRs).
- Constraints (tech stack, cloud/on-prem, security, compliance, budget, timeline).
- Known dependencies and risks.

## Steps

1. Greet the user and clarify whether this is:
   - A brand-new system, OR
   - Modernisation / migration of an existing system.

2. Ask targeted questions in small chunks, and summarise as you go:
   - Business context and goals.
   - Users and usage patterns.
   - Critical business scenarios / flows.
   - NFRs (availability, performance, security, data residency, operations).
   - Constraints and dependencies.

3. Validate your understanding:
   - Present a concise summary of what you heard.
   - Ask the user to confirm or correct.

4. Produce a structured discovery document:
   - Use `templates/rh-discovery-notes-template.yaml` as the structure.
   - Fill in sections based on collected inputs.
   - Clearly mark any assumptions and gaps.

5. Prepare for follow-up tasks:
   - Suggest running `/rhArch create-hld` as the next step.
