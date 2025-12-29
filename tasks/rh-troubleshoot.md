# Task: rh-troubleshoot

## Purpose

Guide user through a structured troubleshooting session for complex
issues that require systematic investigation.

## Troubleshooting Methodology

Follow the scientific method for troubleshooting:

1. **Define** - Clearly state the problem
2. **Gather** - Collect relevant information
3. **Hypothesize** - Form theories about the cause
4. **Test** - Verify or eliminate hypotheses
5. **Identify** - Determine root cause
6. **Remediate** - Fix the issue
7. **Document** - Record findings and solution

## Workflow

### Step 1: Problem Definition

Establish clear problem statement:

**Questions to ask:**
- What is the expected behavior?
- What is the actual behavior?
- When did this start happening?
- What is the impact/severity?
- Is this reproducible?

**Document:**
```markdown
## Problem Statement
- Expected: [what should happen]
- Actual: [what is happening]
- Started: [when]
- Impact: [severity and scope]
- Reproducible: [yes/no/intermittent]
```

### Step 2: Information Gathering

Collect relevant data based on problem type:

#### System Issues
- System logs: `/var/log/messages`, `journalctl`
- Service logs: Application-specific logs
- Resource metrics: CPU, memory, disk, network
- Configuration files: Recent changes

#### Application Issues
- Application logs
- Configuration files
- Dependency status
- Resource allocation

#### Network Issues
- Connectivity tests: ping, traceroute
- DNS resolution
- Firewall rules
- Port availability

#### Cluster Issues
- Cluster status
- Node conditions
- Pod logs and events
- Operator status

### Step 3: Hypothesis Formation

Based on gathered information:

1. List all possible causes
2. Rank by likelihood (based on evidence)
3. Rank by ease of verification
4. Start with most likely AND easiest to verify

**Template:**
```markdown
## Hypotheses
| # | Hypothesis | Likelihood | Evidence | Verification |
|---|------------|------------|----------|--------------|
| 1 | [theory] | High | [what points to this] | [how to verify] |
| 2 | [theory] | Medium | [what points to this] | [how to verify] |
```

### Step 4: Hypothesis Testing

For each hypothesis (starting with most likely):

1. **Predict** - What should we see if this is the cause?
2. **Test** - Run verification command/check
3. **Evaluate** - Does evidence support or contradict?
4. **Conclude** - Confirm, eliminate, or need more data

**Document each test:**
```markdown
### Testing Hypothesis #1: [description]

**Prediction**: If this is the cause, we should see [X]

**Test performed**:
[command or action]

**Result**:
[output or observation]

**Conclusion**: [Confirmed/Eliminated/Inconclusive]
```

### Step 5: Root Cause Identification

When root cause is identified:

1. **State the root cause clearly**
2. **Explain the causal chain** (how it led to symptoms)
3. **Provide evidence** supporting this conclusion
4. **Rule out alternatives** (why other causes were eliminated)

### Step 6: Remediation

Provide solution:

1. **Immediate fix**
   - Step-by-step instructions
   - Commands with expected output
   - Verification steps

2. **Rollback plan**
   - How to revert if fix fails
   - Backup steps if needed

3. **Permanent solution**
   - Long-term fix if different from immediate
   - Configuration changes
   - Process improvements

### Step 7: Documentation

Create troubleshooting record:

```markdown
# Troubleshooting Record

**Date**: [timestamp]
**System**: [affected system]
**Issue**: [brief description]

## Problem
[Problem statement from Step 1]

## Investigation
[Summary of information gathered]

## Root Cause
[Identified root cause with evidence]

## Resolution
[Steps taken to fix]

## Prevention
[How to prevent recurrence]

## Lessons Learned
[What can be improved]
```

## Interaction Guidelines

- Work through steps methodically - don't skip ahead
- Explain reasoning at each step
- Ask for user input when needed
- Present options when multiple paths exist
- Celebrate progress (hypothesis eliminated = progress)
- Don't give up - escalate if beyond scope
- Document everything for future reference
