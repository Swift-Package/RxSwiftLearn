// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxSwiftLearn",
    platforms: [.iOS(.v18), .macOS(.v15), .watchOS(.v11), .tvOS(.v18), .visionOS(.v2)],
    products: [
        .library(name: "RxSwiftLearn", targets: ["RxSwiftLearn"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", branch: "main")
    ],
    targets: [
        .target(name: "RxSwiftLearn", dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(name: "RxSwiftLearnTests",
                    dependencies: ["RxSwiftLearn", "RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),
    ],
    swiftLanguageModes: [.v6, .v5]
)
// MARK: - 学习顺序
// 1 RxSwiftLearnTests
// 2 Subjects
// 3 Relay
// 4 Filter
// 5 Transform
// 6 PropertyListen
// 7 CombiningOperators
// 8 TimeOperators
// 9 ErrorHandle
//
//
//
//
//
//
//
//
//
//
