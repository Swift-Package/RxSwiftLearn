//
//  TimerViewController.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit
import SwiftUI
import RxSwift

// MARK: - interval 示例
class IntervalViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	private var intervalDisposable: Disposable?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("====== interval 示例开始 ======")
		
		let elementsPerSecond = 2
		let intervalTime: RxTimeInterval = .milliseconds(1000 / elementsPerSecond)
		
		// interval 本身就是定时源（冷序列）
		// 第一个值会在订阅者开始观察序列后经过指定的时间间隔后发出,此外计时器在此之前不会启动
		// 订阅操作会触发计时器的运行
		let sourceObservable = Observable<Int>
			.interval(intervalTime, scheduler: MainScheduler.instance)
			.map { index in
				"🐰 \(index + 1)"
			}
			// .share()// 变成热序列直接启动无需订阅
		
		// 第一个订阅：立刻订阅
		let x = sourceObservable
			.subscribe(onNext: { value in
				print("A received:", value)
			})
		
		// 第二个订阅：3 秒后订阅 这个订阅也是从 1 开始计时
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.intervalDisposable = sourceObservable
				.subscribe(onNext: { value in
					print("   B received:", value)
				})
		}
		
		// 10 秒后结束演示 两个订阅都取消
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			print("Demo finished")
			x.dispose()
			self.intervalDisposable?.dispose()
		}
	}
}

#Preview {
	IntervalViewController()
}

//Observable
//	.interval(.seconds(1), scheduler: MainScheduler.instance)
//	.take(5)
//	.subscribe(onNext: { print($0) })
//
//Observable
//	.interval(.seconds(1), scheduler: MainScheduler.instance)
//	.takeUntil(Observable.timer(.seconds(5), scheduler: MainScheduler.instance))
//	.subscribe(onNext: { print($0) })
//
//let stopSignal = PublishSubject<Void>()
//Observable
//	.interval(.seconds(1), scheduler: MainScheduler.instance)
//	.takeUntil(stopSignal)
//	.subscribe(onNext: { print($0) })
//
//// 某个时刻
//stopSignal.onNext(())
//
//Observable
//	.timer(.seconds(5), scheduler: MainScheduler.instance)
//	.subscribe(onNext: { _ in
//		print("只触发一次")
//	})
