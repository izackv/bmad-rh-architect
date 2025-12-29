# Task: rh-analyze-issue

## Purpose

Analyze a specific issue, error message, or incident reported by the user
and provide diagnosis and remediation guidance.

## Workflow

### Step 1: Issue Intake

Gather essential information:

1. **What is the problem?**
   - Error message (exact text)
   - Symptoms observed
   - Expected vs actual behavior

2. **When did it start?**
   - First occurrence
   - Frequency (constant, intermittent, specific times)
   - Any recent changes before the issue

3. **What is affected?**
   - System/service/application name
   - Red Hat product and version
   - Scope (single node, cluster, multiple systems)

4. **What has been tried?**
   - Troubleshooting steps already taken
   - Any temporary workarounds

### Step 2: Environment Context

Determine the environment:
- RHEL version
- OpenShift/Kubernetes version (if applicable)
- Ansible/AAP version (if applicable)
- Deployment type (bare metal, VM, cloud, container)

### Step 3: Error Analysis

For the reported error:

1. **Parse the error message**
   - Identify error code/type
   - Extract relevant component/service
   - Note timestamps and sequence

2. **Categorize the issue**
   - Configuration error
   - Resource exhaustion
   - Permission/security issue
   - Network connectivity
   - Dependency failure
   - Software bug

3. **Identify related logs**
   - Suggest which logs to check
   - Provide commands to extract relevant entries

### Step 4: Documentation Search

Search official sources for:
- Known issues matching the error
- Solution articles
- Release notes mentioning the issue
- Community discussions

Reference:
- Red Hat Customer Portal (access.redhat.com)
- Product documentation
- Knowledge base articles

### Step 5: Diagnosis

Based on gathered information:

1. **Form hypotheses**
   - List possible root causes
   - Rank by likelihood

2. **Verification steps**
   - Commands to confirm/rule out each hypothesis
   - Expected output for each scenario

3. **Root cause identification**
   - Present findings with evidence
   - Explain the causal chain

### Step 6: Remediation

Provide actionable fix:

1. **Immediate actions**
   - Steps to resolve the issue
   - Commands with explanations
   - Expected results

2. **Rollback plan**
   - How to revert if fix doesn't work
   - Backup recommendations

3. **Prevention**
   - How to prevent recurrence
   - Monitoring recommendations

## Output Format

```markdown
# Issue Analysis: [Brief Description]

## Problem Statement
[Clear description of the reported issue]

## Environment
- Product:
- Version:
- Platform:

## Analysis

### Error Details
[Parsed error information]

### Category
[Type of issue]

### Related Documentation
[Links to relevant KB articles, docs]

## Diagnosis

### Hypotheses
1. [Most likely cause] - Likelihood: High/Medium/Low
2. [Alternative cause] - Likelihood: High/Medium/Low

### Verification
[Steps performed and results]

### Root Cause
[Identified root cause with evidence]

## Remediation

### Solution
[Step-by-step fix]

### Rollback Plan
[How to revert if needed]

### Prevention
[How to avoid in future]

## References
[Links to documentation, KB articles]
```

## Interaction Guidelines

- Be patient in gathering information
- Don't assume - ask clarifying questions
- Always reference official documentation
- Provide context for recommended actions
- Offer to explain technical concepts if needed
