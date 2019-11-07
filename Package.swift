// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "WolfViews",
    platforms: [
        .iOS(.v12), .macOS(.v10_13), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "WolfViews",
            targets: ["WolfViews"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfGraphics", from: "1.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLocale", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfAutolayout", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfAnimation", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfApp", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfCache", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "WolfViews",
            dependencies: [
                "WolfCore",
                "WolfGraphics",
                "WolfLocale",
                "WolfAutolayout",
                "WolfAnimation",
                "WolfApp",
                "WolfCache",
            ])
        ]
)
