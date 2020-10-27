// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "iam-middleware",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "iam-middleware", targets: ["IAM"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.32.0"),
    ],
    targets: [
        .target(name: "IAM",
                dependencies: [
                    .product(name: "Vapor", package: "vapor"),
                ]),
        .testTarget(name: "IAMTests", dependencies: [
            .target(name: "IAM")

        ])
    ]
)

