// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "FocusAudio",
    platforms: [.macOS(.v15)],
    products: [.library(name: "FocusAudio", targets: ["FocusAudio"])],
    dependencies: [.package(path: "../FocusDomain")],
    targets: [.target(name: "FocusAudio", dependencies: ["FocusDomain"])],
    swiftLanguageModes: [.v6]
)
