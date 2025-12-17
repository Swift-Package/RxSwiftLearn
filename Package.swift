// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RxSwiftLearn",
    platforms: [.iOS(.v26), .macOS(.v26), .watchOS(.v26), .tvOS(.v26), .visionOS(.v26)],
    products: [
        .library(name: "RxSwiftLearn", targets: ["RxSwiftLearn"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", branch: "main")
    ],
    targets: [
        .target(name: "RxSwiftLearn", 
				dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),
		
        .testTarget(name: "RxSwiftLearnTests", 
					dependencies: ["RxSwiftLearn", "RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),
    ],
    swiftLanguageModes: [.v6]
)

// MARK: - RxSwift: Reactive Programming with Swift - Kedeco
