# Task: rh-estimate-timeline-resources

## Purpose

Provide effort and schedule estimates, including roles and key assumptions.

## Steps

1. Ask the user about:
   - Team size and skill levels.
   - Parallel workstreams possibility.
   - External dependencies (security approvals, infra provisioning).

2. Load structure from `templates/rh-timeline-resources-template.yaml`.

3. Define phases and work packages:
   - Discovery, design, build, test, go-live, hypercare, handover.

4. Estimate:
   - Person-days per role per phase.
   - Calendar duration per phase, considering overlap and constraints.

5. Identify risks and buffers:
   - Mark which items are high uncertainty.
   - Suggest reasonable buffers (time and/or capacity).

6. Present a concise summary:
   - Table + short narrative explanation.
