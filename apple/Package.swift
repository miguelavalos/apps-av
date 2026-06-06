// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AppsAV",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AVDiagnosticsFoundation",
            targets: ["AVDiagnosticsFoundation"]
        ),
        .library(
            name: "AVHaptics",
            targets: ["AVHaptics"]
        ),
        .library(
            name: "AVBrandFoundation",
            targets: ["AVBrandFoundation"]
        ),
        .library(
            name: "AVAppShellFoundation",
            targets: ["AVAppShellFoundation"]
        ),
        .library(
            name: "AVLaunchFoundation",
            targets: ["AVLaunchFoundation"]
        ),
        .library(
            name: "AVSettingsFoundation",
            targets: ["AVSettingsFoundation"]
        ),
        .library(
            name: "AVAviFoundation",
            targets: ["AVAviFoundation"]
        ),
        .library(
            name: "AVPaywallFoundation",
            targets: ["AVPaywallFoundation"]
        ),
        .library(
            name: "AVMediaAnalysisFoundation",
            targets: ["AVMediaAnalysisFoundation"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "AVDiagnosticsFoundation",
            dependencies: [
                .product(name: "Sentry", package: "sentry-cocoa")
            ]
        ),
        .target(name: "AVMediaAnalysisFoundation"),
        .target(
            name: "AVPaywallFoundation",
            dependencies: ["AVBrandFoundation"]
        ),
        .target(
            name: "AVAviFoundation",
            dependencies: ["AVBrandFoundation"]
        ),
        .target(
            name: "AVAppShellFoundation",
            dependencies: ["AVBrandFoundation"]
        ),
        .target(
            name: "AVLaunchFoundation",
            dependencies: ["AVBrandFoundation"]
        ),
        .target(
            name: "AVSettingsFoundation",
            dependencies: ["AVAppShellFoundation", "AVAviFoundation", "AVBrandFoundation", "AVLaunchFoundation"]
        ),
        .target(name: "AVBrandFoundation"),
        .target(name: "AVHaptics"),
        .testTarget(
            name: "AVDiagnosticsFoundationTests",
            dependencies: ["AVDiagnosticsFoundation"]
        )
    ]
)
