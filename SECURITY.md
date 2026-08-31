# Security policy

The packages in this repository are unaudited alphas. Successful installation,
protocol conformance or testnet execution does not authorize production-value
use.

Report suspected vulnerabilities privately to `security@reuna.io`. Do not open
a public issue for a signing, parser, key-handling, transaction-policy or
dependency-integrity weakness before a coordinated fix is available. Include
the affected package/version, impact, reproducer and whether any secret or live
asset was involved. Never attach reusable keys or seeds.

## Defensive testing authorization

The current program authorizes defensive testing of Reuna-owned source,
packages and explicitly configured testnet workflows. It does not authorize
intrusive testing of public RPC providers, upstream projects or other third
parties. Network evidence must use low-value disposable testnet accounts and
the repository's environment-gated workflows.

See `security/review-plan.md` for the review and fuzzing gates.
