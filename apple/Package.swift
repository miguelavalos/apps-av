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
        )
    ],
    targets: [
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
        .target(name: "AVHaptics")
    ]
)
