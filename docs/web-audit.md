# Apps AV Web Audit

Status: current as of 2026-06-18.

Apps AV commercial web was checked as part of the AV web visual audit.
Series AV is now the first production reference for the shared Apps AV web
package.

## Contract

- User-facing web content supports `en`, `es`, `fr`, `de`, and `ca`.
- AV-owned links preserve the active language.
- The commercial surface may use AVALSYS naming where legal, brand, or company
  context requires it.
- Shared Apps AV web packages remain the source for product app shell, locale,
  and footer behavior.
- Shared Account and Settings screens should stay one-to-one across product web
  apps in content model, icon semantics, section ordering, and visual grammar.
- Product apps should compose shared Apps AV web components with Account AV web
  session/access state rather than copying common UI into product repos.

## Latest Audit Result

- Desktop and mobile browser QA passed.
- Localized commercial headlines were polished.
- Footer links to AV-owned surfaces preserve language.
- The shared app shell logo now uses the localized Home nav link when a product
  app provides one, so app-owned logo navigation preserves the active language.
- Series AV promoted the reusable app foundation for later product web apps:
  `AppShell`, mobile navigation, `AvAppFooter`, `ProtectedAppGate`, app state
  surfaces, compact sync status, Account/Settings scaffolds, Pro/sync/safety and
  help/legal sections, theme preference helpers, locale helpers, and localized
  link helpers.
- The shared package intentionally does not own product catalog/workflow data,
  auth provider integration, bearer tokens, billing policy, or account deletion
  behavior. Product apps use Account AV web for account/session/access state and
  product APIs only for product data.
- The Series AV production validation added a reusable deployment lesson:
  after product web deploy, check Account AV and product API CORS from the
  production app origin before diagnosing browser `Failed to fetch` as a
  frontend issue.
- Build and preview smoke checks passed during the audit.
