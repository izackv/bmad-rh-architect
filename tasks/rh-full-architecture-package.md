# Task: rh-full-architecture-package

## Purpose

Drive an end-to-end flow that produces:
- Discovery notes
- HLD
- LLD
- Cost estimate
- Timeline & resource estimate
- Project plan

## Steps

1. Check what already exists:
   - Ask the user which artefacts are already available.
   - Skip generation for those that are done and approved.

2. If discovery is missing:
   - Run `rh-discovery-session`.

3. If HLD is missing:
   - Run `rh-create-hld`.

4. If LLD is missing:
   - Run `rh-create-lld`.

5. Generate:
   - `rh-estimate-costs`
   - `rh-estimate-timeline-resources`
   - `rh-create-project-plan`

6. Produce a package summary:
   - List all generated artefacts.
   - Provide a short executive summary.
   - Highlight any open issues and risks.
