//
//  TimeoutViewController.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit
import SwiftUI
import RxSwift

// MARK: - timeout 示例
class TimeoutViewController: UIViewController {
	
	deinit {
		timer?.cancel()
		timer = nil
	}
	
	let disposeBag = DisposeBag()
	private var emittedCount = 0
	private var timer: DispatchSourceTimer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("====== timeout 示例开始 ======")
		
		let elementsPerSecond = 2           // 正常每 0.5s 一个
		let timeoutInterval: RxTimeInterval = .seconds(2)
		
		let sourceObservable = PublishSubject<String>()
		
		// GCD timer：前半段正常后半段故意“卡住”
		timer = DispatchSource.makeTimerSource(queue: .main)
		timer?.schedule(deadline: .now(), repeating: 1.0 / Double(elementsPerSecond))
		timer?.setEventHandler { [weak self] in
			guard let self else { return }
			
			self.emittedCount += 1
			// 第 6 个之后故意不再发（模拟网络卡死）
			if self.emittedCount <= 5 {
				let value = "📡 \(self.emittedCount)"
				print("emit:", value)
				sourceObservable.onNext(value)
			}
		}
		timer?.resume()
		
		sourceObservable
			.timeout(timeoutInterval, scheduler: MainScheduler.instance)
		//.timeout(.seconds(2), other: Observable.just("⚠️ fallback"), scheduler: MainScheduler.instance)// 超时后切换备用序列
			.subscribe(
				onNext: { value in
					print("received:", value)
				},
				onError: { error in
					print("❌ timeout error:", error)
				},
				onCompleted: {
					print("completed")
				}
			)
			.disposed(by: disposeBag)
	}
}

#Preview {
	TimeoutViewController()
}
//====== timeout 示例开始 ======
//emit: 📡 1
//received: 📡 1
//emit: 📡 2
//received: 📡 2
//emit: 📡 3
//received: 📡 3
//emit: 📡 4
//received: 📡 4
//emit: 📡 5
//received: 📡 5
//❌ timeout error: Sequence timeout.
