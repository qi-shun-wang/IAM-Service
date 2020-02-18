// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "fd-iam-service",
    products: [
        .library(name: "IAM", targets: ["IAM"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.3"),
    ],
    targets: [
        .target(name: "IAM", dependencies: [ "Vapor"]),
        .testTarget(name: "IAMTests", dependencies: ["Vapor", "IAM"])
    ]
)

