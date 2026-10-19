---
name: infra-audit
description: Parallel infrastructure audit — security, cost, and drift checks
context: fork
disable-model-invocation: true
---

Run three audits in parallel with the project subagents and compile one report.

Launch these three subagents in parallel:

**security-auditor:** audit `terraform/*.tf` and `.github/workflows/deploy.yml`. Returns CRITICAL/HIGH/MEDIUM/LOW findings with fixes.

**cost-optimizer:** review `terraform/*.tf` for cost-incurring resources and optimizations, with estimated impact.

**drift-detector:** run `terraform plan -detailed-exitcode` and analyze any drift between Terraform and AWS.

After all three complete, compile a single report with these sections:
## Security Findings
## Cost Optimization
## Drift Status
## Summary (overall verdict and the top 3 actions)
