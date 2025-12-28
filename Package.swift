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
				dependencies: ["RxSwift",
							   .product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(name: "RxSwiftLearnTests",
					dependencies: ["RxSwiftLearn",
								   "RxSwift",
								   .product(name: "RxCocoa", package: "RxSwift")]),
    ],
    swiftLanguageModes: [.v6]
)

// MARK: - RxSwift: Reactive Programming with Swift - Kedeco
// Traits 特性
// 1.不会出错
// 2.在主线程调度
// 3.资源共享: 
//		Driver 自动获取 share(replay: 1)
//		Signal 自动获取 share()
//
// ControlProperty 	表示可读可修改的对象属性
// COntrolEvent		用于监听 UI 组件特定事件例如按下键盘回车键
// Driver			不会出错/主线程执行/共享资源并在新订阅时重放最新值 .asDriver(onErrorJustReturn: .empty)/.drive(tempLabel.rx.text)
// Signal			不会出错/主线程执行/共享资源
