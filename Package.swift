// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Package version: 2.4.74

import PackageDescription

let package = Package(
    name: "AICore",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AICore",
            targets: ["AICore"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://gitlab.com/alexyib/ainetworkcalls.git", from: "1.5.13"),
        .package(url: "https://github.com/relatedcode/ProgressHUD.git", from: "13.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://gitlab.com/alexyib/aienvironmentkit.git", from: "1.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
        .package(url: "https://github.com/google/promises.git", from: "2.0.0"),
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", from: "16.1.0"),
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AICore",
            dependencies: [
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "AIEnvironmentKit", package: "aienvironmentkit"),
                .product(name: "AINetworkCalls", package: "ainetworkcalls"),
                .product(name: "ProgressHUD", package: "ProgressHUD"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "Sentry", package: "sentry-cocoa"),
                .product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebasePerformance", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk"),
                .product(name: "SwiftDate", package: "SwiftDate"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Promises", package: "promises"),
                .product(name: "SocketIO", package: "socket.io-client-swift"),
                .product(name: "Starscream", package: "Starscream"),
            ]
        ),
        .testTarget(
            name: "AICoreTests",
            dependencies: ["AICore"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
