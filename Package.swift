// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ConvayMeetSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ConvayMeetSDK",
            targets: ["ConvayMeetSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ConvayMeetSDK",
            path: "Frameworks/ConvayMeetSDK.xcframework"
        )
    ]
)
