// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-random",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27")
    ],
    products: [
        .library(
            name: "Random",
            targets: ["Random"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-random-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-darwin.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-linux.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-windows.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Random",
            dependencies: [
                .product(name: "Random Primitives", package: "swift-random-primitives"),
                .product(name: "Darwin Kernel", package: "swift-darwin", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux Kernel", package: "swift-linux", condition: .when(platforms: [.linux])),
                .product(name: "Windows Kernel", package: "swift-windows", condition: .when(platforms: [.windows]))
            ]
        ),
        .testTarget(
            name: "Random Tests",
            dependencies: [
                "Random",
            ],
            path: "Tests/Random Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
