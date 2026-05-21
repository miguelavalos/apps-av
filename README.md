# Apps AV

Shared Swift packages for AV apps.

`AppsAV` contains small Apple-platform libraries shared by Tune AV, Moments AV, Series AV, and other AV apps. Keep product-specific behavior in each app; use this repo for cross-app primitives that should behave consistently everywhere.

## Products

### AVHaptics

`AVHaptics` provides a semantic haptics API for common app events:

```swift
import AVHaptics

AVHaptics.perform(.save)
AVHaptics.perform(.playbackToggle)
AVHaptics.perform(.warning)
```

The implementation uses native platform feedback:

- iOS: `UISelectionFeedbackGenerator`, `UIImpactFeedbackGenerator`, and `UINotificationFeedbackGenerator`
- macOS: `NSHapticFeedbackManager`

## Installation

During local development, add the package by path:

```swift
.package(path: "../apps-av")
```

For app repositories that live next to this package, use the relative path that matches the app project. For example, from `public/tune-av/apps/ios` the package path is `../../../apps-av`.

When publishing a stable release, prefer pinning this package by Git tag.

## Requirements

- iOS 18+
- macOS 14+
- Swift 6
