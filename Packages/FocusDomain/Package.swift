// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FocusDomain",
    platforms: [.macOS(.v15)],
    products: [.library(name: "FocusDomain", targets: ["FocusDomain"])],
    targets: [.target(name: "FocusDomain")],
    swiftLanguageModes: [.v6]
)
