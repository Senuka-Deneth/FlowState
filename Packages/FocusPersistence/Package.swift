// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FocusPersistence",
    platforms: [.macOS(.v15)],
    products: [.library(name: "FocusPersistence", targets: ["FocusPersistence"])],
    dependencies: [.package(path: "../FocusDomain")],
    targets: [.target(name: "FocusPersistence", dependencies: ["FocusDomain"])],
    swiftLanguageModes: [.v6]
)
