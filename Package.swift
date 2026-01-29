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
            targets: ["ConvayMeetSDKWrapper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jitsi/webrtc", from: "124.0.0"),
        .package(
            url: "https://github.com/Giphy/giphy-ios-sdk",
            .revision("cdefbedc9f99d40cc64667a2bfaae67a1cf36fbb")
        )
    ],
    targets: [
        .binaryTarget(
            name: "ConvayMeetSDK",
            path: "Frameworks/ConvayMeetSDK.xcframework"
        ),
        .target(
            name: "ConvayMeetSDKWrapper",
            dependencies: [
                .target(name: "ConvayMeetSDK"),
                .product(name: "WebRTC", package: "webrtc"),
                .product(name: "GiphyUISDK", package: "giphy-ios-sdk")
            ],
            path: "Sources"
        )
    ]
)
