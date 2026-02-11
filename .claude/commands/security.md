# /security

Run a security audit using the security-reviewer agent.

## Usage
```
/security [files or area to audit]
```

## Prompt

You are coordinating a security review. Use the security-reviewer agent to audit the specified files or area.

If no target specified, audit authentication and API endpoints.

**Security Review Process:**
1. Identify the security-sensitive areas to review
2. Launch the security-reviewer agent
3. Check for OWASP Top 10 vulnerabilities
4. Review authentication, authorization, and data handling
5. Report findings with severity and remediation steps

**Arguments provided:** $ARGUMENTS
