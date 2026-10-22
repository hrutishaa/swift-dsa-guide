// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DSA",
    products: [
        .library(name: "DSA", targets: ["DSA"])
    ],
    targets: [
        .target(name: "DSA"),
        .testTarget(name: "DSATests", dependencies: ["DSA"])
    ]
)
