// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Transmission",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Transmission", targets: ["Transmission"]),
    ],
    targets: [
        .target(name: "Transmission"),
        .testTarget(name: "TransmissionIntegrationTests", dependencies: [.target(name: "Transmission")]),
    ]
)
