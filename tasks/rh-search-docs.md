# Task: rh-search-docs

## Purpose

Search Red Hat official documentation and knowledge base to find
solutions, best practices, and technical information.

## Search Sources

### Primary Sources

1. **Red Hat Customer Portal** (access.redhat.com)
   - Knowledge base articles
   - Solution articles
   - Technical briefs

2. **Product Documentation**
   - RHEL: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/
   - OpenShift: https://docs.openshift.com/
   - Ansible: https://docs.ansible.com/ and https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/
   - Keycloak/RHBK: https://docs.redhat.com/en/documentation/red_hat_build_of_keycloak/

3. **Release Notes & Known Issues**
   - Product release notes
   - Errata advisories
   - Bug tracking (Bugzilla)

### Secondary Sources

- Red Hat Blog (technical articles)
- Red Hat Developer (developer.redhat.com)
- Upstream project documentation

## Search Workflow

### Step 1: Understand the Query

Clarify what the user is looking for:
- Specific error or issue resolution
- How-to / procedural guidance
- Best practices / recommendations
- Feature documentation
- Compatibility information

### Step 2: Identify Product Context

Determine:
- Which Red Hat product(s)
- Product version
- Deployment context (cloud, on-prem, hybrid)

### Step 3: Formulate Search

Construct effective search terms:
- Include product name and version
- Use exact error codes/messages
- Include relevant component names
- Try both technical and descriptive terms

### Step 4: Search and Filter

Execute search and filter results:
- Prioritize official Red Hat sources
- Check publication date for relevance
- Verify version compatibility
- Look for related articles

### Step 5: Synthesize Results

Present findings:
- Summarize key information
- Quote relevant sections
- Provide direct links
- Note any caveats or version dependencies

## Output Format

```markdown
# Documentation Search: [Topic]

## Query Summary
[What was searched and why]

## Key Findings

### [Finding 1 Title]
**Source**: [URL]
**Relevance**: [Why this is relevant]

[Summary or relevant excerpt]

### [Finding 2 Title]
**Source**: [URL]
**Relevance**: [Why this is relevant]

[Summary or relevant excerpt]

## Recommendations
[Which source best addresses the user's need]

## Related Topics
[Other relevant documentation the user might find useful]

## Notes
[Any caveats, version dependencies, or limitations]
```

## Search Tips

- For errors: Search exact error message in quotes
- For procedures: Include action verbs (configure, install, troubleshoot)
- For compatibility: Include both product versions
- For best practices: Include "best practice" or "recommended"

## Interaction Guidelines

- Ask for clarification if query is ambiguous
- Present multiple sources when available
- Explain relevance of each result
- Offer to search for related topics
- Note if official documentation is lacking
