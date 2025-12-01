# Task: rh-estimate-costs

## Purpose

Create a structured cost estimate covering infra, Red Hat subscriptions,
and relevant tooling, using the cost template.

## Steps

1. Ask the user:
   - Target environment (on-prem / cloud + which provider).
   - Expected scale (environments, clusters, nodes, sizing ballpark).
   - Time horizon (1 year, 3 years, etc.).
   - Whether Red Hat subscription pricing is already known or approximate.

2. Load structure from `templates/rh-cost-estimate-template.yaml`.

3. Build a bill of materials (BOM):
   - Compute, storage, network.
   - Red Hat subscriptions/licenses (OpenShift, RHEL, Ansible, etc.),
     using placeholders or ranges if exact prices are not known.
   - Optional tools/services (monitoring, security tools, etc.).

4. Split costs into:
   - One-off vs recurring,
   - Different scenarios if requested (min/base/high).

5. State all assumptions clearly:
   - Node sizes, discounts, reserved vs on-demand, etc.

6. Produce a clear summary for management:
   - Totals, key cost drivers, notes on risks and contingency.
