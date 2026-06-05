# Apps AV Agent Rules

Apps AV contains shared client primitives for AV product apps. It should define
reusable UI, launch, settings, paywall, haptics, branding, and platform
contracts, not product-specific ownership, credit, render, subscription, or
deletion workflows.

For any native app workflow validation that touches signed account state,
backend-owned identity, subscriptions, purchases, credits, uploads, Convex,
Cloudflare APIs, or deletion flows, follow the private AVALSYS guides. Do not
invent a local runtime flow from this public repo.

- `private/avalsys-suite/docs/platform/native-preview-dev-validation-guide.md`
- `private/avalsys-suite/docs/platform/native-account-identity-contract.md`

Mandatory rules:

- use Cloudflare preview for signed API runtime;
- use Convex cloud `dev`, not local Convex, when a native app workflow depends
  on Convex-backed state;
- do not use `wrangler dev` or another local Worker as product app backend;
- use Infisical/Varlock-backed private tooling for config, deploy keys, and
  secret resolution;
- keep private URLs, service identifiers, approval status, and operations
  evidence out of this public repo;
- do not add product-specific workflow branches to shared UI primitives;
- keep Account AV provider session identity separate from internal Apps AV user
  identity.

If the private repo is unavailable, stop and say that the authoritative runbook
cannot be checked. Do not substitute a guessed local workflow.
