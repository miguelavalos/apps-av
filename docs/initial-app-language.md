# Initial App Language

Apps AV products with EN/ES/CA/FR/DE interfaces share one first-launch rule:

1. keep a valid stored app-language preference;
2. otherwise use the device or browser's primary preferred language when it is
   English, Spanish, Catalan, French, or German;
3. otherwise use English.

Regional tags are canonicalized by their primary language subtag (`es-ES` to
`es`, `ca_ES` to `ca`). Similar-looking words are not language tags, and an
unsupported primary language does not cause the app to scan secondary device
languages.

The Apple **Module** is `AVSettingsFoundation`. Its pure **Interface**,
`AVInitialAppLanguage`, owns normalization and resolution. Each product's small
storage **Adapter** is the deliberate **Seam**: it supplies the local
`UserDefaults` key and persists the canonical result. This keeps the policy
consistent while leaving product copy and settings UI local.

The first resolved language is persisted. Later device-language changes do not
silently change the app, and an explicit in-app language selection always wins.
Web products apply the same rule only when no explicit URL language or valid
locale cookie exists.

DuelWords initializes both interface and game language from this first-run
choice. They remain independent after that initialization so a user can change
the interface without changing an existing duel's word language.
