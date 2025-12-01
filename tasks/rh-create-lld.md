# Task: rh-create-lld

## Purpose

Create a Low-Level Design (LLD) that can be directly used by implementation teams,
aligned with the approved HLD.

## Steps

1. Ask the user for:
   - Link to or copy of the approved HLD; OR
   - Confirmation that the last HLD generated is the baseline.

2. Load structure from `templates/rh-lld-template.yaml`.

3. For each section:
   - Translate high-level decisions into:
     - Concrete cluster/infrastructure topology.
     - Namespaces/projects and resource limits.
     - Security and IAM details.
     - Network and connectivity details.
     - CI/CD and operations details.

4. Use Red Hat best practices:
   - For OpenShift, reference:
     - Recommended operator usage,
     - Multi-tenancy patterns,
     - Hardening guidelines (as far as they are generally known).
   - For RHEL, mention:
     - Standardised builds, patching, and lifecycle management.

5. Ensure traceability:
   - For every major item, reference the related HLD decisions or requirements.

6. Present the LLD to the user:
   - Offer options for:
     - Full document,
     - Implementation checklist,
     - Diagrams (described in text).
