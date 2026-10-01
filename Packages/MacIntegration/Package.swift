// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MacIntegration",
    platforms: [.macOS(.v15)],
    products: [.library(name: "MacIntegration", targets: ["MacIntegration"])],
    targets: [.target(name: "MacIntegration")],
    swiftLanguageModes: [.v6]
)
