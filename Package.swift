// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfViews",
    platforms: [
        .iOS(.v12), .macOS(.v10_13), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "WolfViews",
            type: .dynamic,
            targets: ["WolfViews"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfLocale", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfAutolayout", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfAnimation", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfApp", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfCache", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfOSBridge", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfColor", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfGeometry", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfImage", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfPipe", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfWith", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNumerics", from: "4.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfConcurrency", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfStrings", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNesting", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNIO", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WolfViews",
            dependencies: [
                "WolfLocale",
                "WolfAutolayout",
                "WolfAnimation",
                "WolfApp",
                "WolfCache",
                "WolfOSBridge",
                "WolfColor",
                "WolfGeometry",
                "WolfImage",
                "WolfPipe",
                "WolfFoundation",
                "WolfWith",
                "WolfNumerics",
                "WolfConcurrency",
                "WolfStrings",
                "WolfNesting",
                "WolfNIO",
            ])
        ]
)
