# Apps AV

Shared libraries for AV apps.

`apps-av` contains cross-app building blocks for AV products such as Tune AV, Moments AV, Series AV, and future apps. Keep product-specific behavior in each app; use this repo for primitives that should behave consistently across products.

Platform-specific libraries live in dedicated folders:

- `apple/`: Swift packages for Apple platforms

Future platform folders can be added as needed, for example `android/`, `kotlin/`, or `web/`.

## Product App Patterns

New Apple product apps should follow the shared Apps AV bootstrap and
integration guide:

- [Apps AV Apple Product App Patterns](docs/apple-product-app-patterns.md)

That guide explains how public Apple clients should consume `apps-av/apple` and
`account-av` consistently while keeping product-specific workflows in each app.

## Apple

The Apple Swift package lives in `apple/`.

Current products:

- `AVBrandFoundation`: shared brand tokens for Apple app UI foundations
- `AVAppShellFoundation`: shared Apple app shell scaffold primitives
- `AVLaunchFoundation`: shared Apple splash and launch transition primitives
- `AVSettingsFoundation`: shared Apple settings, account, and legal surface primitives
- `AVAviFoundation`: shared Apple Avi UI primitives without app-specific behavior
- `AVPaywallFoundation`: shared Apple paywall and upgrade prompt UI primitives
- `AVHaptics`: semantic haptics for common app events

During local development, apps can add the Apple package by path. For app repositories that live next to this package, use the relative path that matches the app project. For example, from `public/tune-av/apps/ios` the package path is `../../../apps-av/apple`.

When publishing a stable release, prefer pinning this package by Git tag.
