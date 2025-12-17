//
//  DelaySubscriptionViewController.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit
import SwiftUI
import RxSwift

// MARK: - 延迟订阅
class DelaySubscriptionViewController: UIViewController {
	
	deinit {
		timer?.cancel()
		timer = nil
	}
	
	let disposeBag = DisposeBag()
	private var emittedCount = 0
	private var timer: DispatchSourceTimer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("====== delaySubscription 示例开始 ======")
		
		let elementsPerSecond = 2
		let delayTime: RxTimeInterval = .seconds(5)
		
		let sourceObservable = PublishSubject<String>()
		
		timer = DispatchSource.makeTimerSource(queue: .main)
		timer?.schedule(deadline: .now(), repeating: 1.0 / Double(elementsPerSecond))
		timer?.setEventHandler { [weak self] in
			guard let self else { return }
			self.emittedCount += 1
			let value = "🐶 \(self.emittedCount)"
			print("emit:", value)
			sourceObservable.onNext(value)
		}
		timer?.resume()
		
		sourceObservable
			//.delaySubscription(delayTime, scheduler: MainScheduler.instance)	// 延迟 5 秒订阅丢失之前的数据
			.delay(delayTime, scheduler: MainScheduler.instance)				// 延迟 5 秒订阅但不丢失之前的数据
			.subscribe(
				onNext: { value in
					print("   received:", value)
				},
				onCompleted: {
					print("completed")
				}
			)
			.disposed(by: disposeBag)
		
		// 20 秒后停止发射
		DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
			self?.timer?.cancel()
			self?.timer = nil
			sourceObservable.onCompleted()
			print("Stopped timer and completed source")
		}
	}
}

#Preview {
	DelaySubscriptionViewController()
}
