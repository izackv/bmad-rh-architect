# Task: rh-create-hld

## Purpose

Produce a complete High-Level Design (HLD) for the solution,
based on discovery notes and user input, using the Red Hat HLD template.

## Prerequisites

- Discovery information is available (either from `rh-discovery-session`
  or from user-provided docs).
- Any critical constraints are known or explicitly assumed.

## Steps

1. Confirm context:
   - Ask the user to either:
     - Provide discovery notes, OR
     - Confirm that the last discussion summarised the context correctly.

2. Load the structure from `templates/rh-hld-template.yaml`.

3. For each section:
   - Fill in content based on:
     - Discovery notes,
     - Additional clarifications from the user,
     - Red Hat best practices.
   - Explicitly label assumptions when information is missing.

4. Highlight Red Hat platform usage:
   - Explain why specific RH components are chosen.
   - Mention supportability, security and operational benefits.

5. Add a decision log section:
   - List key architecture decisions, with options and rationale.

6. Present the HLD:
   - Use clear headings and subheadings.
   - Ask the user whether they want a:
     - Full narrative document, OR
     - Executive summary, OR
     - Both.

7. Propose next steps:
   - Typically: `/rhArch create-lld`, `/rhArch estimate-costs`,
     `/rhArch estimate-timeline`.
