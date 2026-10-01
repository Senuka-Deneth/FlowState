// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FlowStateChecks",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(path: "Packages/FocusDomain"),
        .package(path: "Packages/FocusPersistence"),
        .package(path: "Packages/FocusAudio"),
        .package(path: "Packages/MacIntegration"),
    ],
    targets: [
        .testTarget(
            name: "FoundationTests",
            dependencies: [
                .product(name: "FocusDomain", package: "FocusDomain"),
                .product(name: "FocusPersistence", package: "FocusPersistence"),
                .product(name: "FocusAudio", package: "FocusAudio"),
                .product(name: "MacIntegration", package: "MacIntegration"),
            ],
            path: "Tests/FoundationTests"
        )
    ],
    swiftLanguageModes: [.v6]
)
