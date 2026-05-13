// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JityApiClient",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "JityApiClient",
            targets: ["JityApiClient"]
        )
    ],
    targets: [
        .target(
            name: "JityApiClient",
            path: "Sources/JityApiClient"
        )
    ]
)
