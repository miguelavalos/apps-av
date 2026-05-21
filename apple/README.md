# Apps AV Apple

Swift packages for AV apps on Apple platforms.

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
.package(path: "../apps-av/apple")
```

For app repositories that live next to this package, use the relative path that matches the app project. For example, from `public/tune-av/apps/ios` the package path is `../../../apps-av/apple`.

When publishing a stable release, prefer pinning this package by Git tag.

## Requirements

- iOS 18+
- macOS 14+
- Swift 6
