# Apps AV Agent Rules

Before work that touches signed runtime, backend-owned identity, billing,
deletion, deployment, TestFlight/App Store, Convex, Cloudflare remote state, or
cross-app workflow behavior, run the private workspace preflight first:

```bash
bash ../../private/avalsys-suite/scripts/agent-preflight.sh --app apps-av --intent <intent>
```

Read `../../private/avalsys-suite/docs/agents/workspace-guardrails.md` and every doc
printed by the preflight before executing commands. If the private repo is
unavailable, stop instead of guessing.

For local iOS/macOS builds, also follow
`../../private/avalsys-suite/docs/agents/native-cache-hygiene.md`: use
repo-local purpose-named `-derivedDataPath` directories and remove repo-local
`.DerivedData*`/`.derived-data*` caches after the task when no build is using
them.

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
- `private/avalsys-suite/docs/platform/account-av-ios-testflight-contract.md`
- `private/avalsys-suite/docs/agents/plan-step.md` when the user says
  `usa plan-step` or asks for step-by-step plan execution.
- `private/avalsys-suite/docs/agents/plan-goal.md` when the user says
  `usa plan-goal` or asks for reviewed full-plan execution.

Mandatory rules:

- use Cloudflare preview for signed API runtime;
- use Convex cloud `dev`, not local Convex, when a native app workflow depends
  on Convex-backed state;
- do not use `wrangler dev` or another local Worker as product app backend;
- use Infisical/Varlock-backed private tooling for config, deploy keys, and
  secret resolution;
- keep private URLs, service identifiers, approval status, and operations
  evidence out of this public repo;
- shared public Apple product docs must describe the Account AV iOS keychain
  contract without exposing private config values;
- do not add product-specific workflow branches to shared UI primitives;
- keep Account AV provider session identity separate from internal Apps AV user
  identity.

If the private repo is unavailable, stop and say that the authoritative runbook
cannot be checked. Do not substitute a guessed local workflow.
