// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-random",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Random",
            targets: ["Random"]
        ),
    ],
    dependencies: [
        .package(path: "../../swift-primitives/swift-random-primitives"),
        .package(path: "../swift-darwin"),
        .package(path: "../swift-linux"),
        .package(path: "../swift-windows"),
        .package(path: "../swift-testing-extras"),
    ],
    targets: [
        .target(
            name: "Random",
            dependencies: [
                .product(name: "Random Primitives", package: "swift-random-primitives"),
                .product(name: "Darwin Kernel", package: "swift-darwin", condition: .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS])),
                .product(name: "Linux Kernel", package: "swift-linux", condition: .when(platforms: [.linux])),
                .product(name: "Windows Kernel", package: "swift-windows", condition: .when(platforms: [.windows])),
            ]
        ),
        .testTarget(
            name: "Random Tests",
            dependencies: [
                "Random",
                .product(name: "Testing Extras", package: "swift-testing-extras"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
