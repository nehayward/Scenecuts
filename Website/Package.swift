// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ScenecutsWebsite",
    products: [
        .executable(
            name: "ScenecutsWebsite",
            targets: ["ScenecutsWebsite"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "ScenecutsWebsite",
            dependencies: ["Publish"]
        )
    ]
)