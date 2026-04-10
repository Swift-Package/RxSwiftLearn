// swift-tools-version: 6.3
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

// MARK: - RxSwift: Reactive Programming With Swift - Kedeco
// MARK: - 一步一步进化封装
// MARK: - 1.Observable(只读只能作为被观察者)
//		just		只发出一个元素和一个 completed 事件
//		of
//		from
//		empty		不发出任何元素随后发出一个 completed 事件
//		error		只发出一个 error 事件
//		never		永远不发出任何元素
//		range
//		create 		自定义
//		deferred 	自定义
//
// MARK: - 2.Subject 主题类型 (总共四种其中常用的是下面的三种)
//		PublishSubject 	初始状态为空,仅向订阅者发送新元素并且完成事件之后只会向新订阅者发送完成事件
//		BehaviorSubject 发送最新事件给新订阅者
//		ReplaySubject 	缓冲指定数量事件给新订阅者
//
// MARK: - 3.对 Subject 主题的封装类型 Relay
//		PublishRelay 	不会发出完成事件和错误事件且只能 accept 值
//		BehaviorRelay 	不会发出完成事件和错误事件且只能 accept 值
//
// MARK: - 4.Traits 特性(特殊的 Observable 变体)
// 1.不会出错
// 2.在主线程调度
// 3.资源共享:
//		Driver 自动获取 share(replay: 1)
//		Signal 自动获取 share()
//
// ControlProperty 	表示可读可修改的对象属性
// ControlEvent		用于监听 UI 组件特定事件例如按下键盘回车键
// Driver			不会出错/主线程执行/共享资源并在新订阅时重放最新值 .asDriver(onErrorJustReturn: .empty)/.drive(tempLabel.rx.text)
// Signal			不会出错/主线程执行/共享资源
//
// MARK: - 5.Trait 特化对象
// Single 		-> success(value) / error(Error)
// Maybe		-> success(value) / completed / error(Error)
// Completable 	-> completed / error(Error)
// 如果我们继续以照片相关的例子为 例Maybe 假设你的应用将照片存储在自定义相册中
// 你将相册标识符持久化到 UserDefaults 中，每次“打开”相册并写入照片时都使用该 ID。你需要设计一个open(albumId:) -> Maybe<String>方法来处理以下情况：
// 如果具有给定 ID 的专辑仍然存在，则只需发出一个.completed事件
// 如果用户在此期间删除了专辑，请创建一个新专辑并发出一个.next带有新 ID 的事件以便您可以将其持久化UserDefaults
// 如果出现错误您完全无法访问照片库请发出一个.error事件
// andThen操作符允许你在成功事件发生后链接更多可完成对象或可观察对象
//
// 在这个例子中，你imageCache在原本简洁的代码中引入了状态（即 `state`）。不必过于担心：在第 9 章“组合运算符”中，你将学习 `state` 运算符scan，它能帮助你解决这类问题
// 上面的代码直接访问了视图控制器的属性，这在响应式编程中是一种颇具争议的做法。在第 9 章“组合运算符”中，你将学习如何组合多个可观察序列，从而避免使用视图控制器来维护状态
//
//
