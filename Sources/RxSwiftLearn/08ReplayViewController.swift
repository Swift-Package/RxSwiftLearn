//
//  ReplayViewController.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit
import SwiftUI
import RxSwift

// MARK: - 重放序列元素 Replay
class ReplayViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let elementsPerSecond = 1	// 每秒发送个元素个数
		let maxElements = 5		// 最大发送元素个数
		let replayedElements = 1	// 重放元素个数
		let replayDelay: TimeInterval = 3// 延迟多少秒后增加订阅
		
		let sourceObservable = Observable<Int>.create { observer in
			var value = 1
			let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
				if value <= maxElements {
					observer.onNext(value)
					value += 1
				}
			}
			return Disposables.create {
				timer.suspend()
			}
		}
			.replay(replayedElements)
		// .replayAll()
		
		let _ = sourceObservable
			.subscribe { value in
				print(value)
			}
			.disposed(by: disposeBag)
		
		// 延迟一段时间后再添加另一个订阅
		DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
			let _ = sourceObservable
				.subscribe { value in
					print(value)
				}
				.disposed(by: self.disposeBag)
		}
		
		_ = sourceObservable.connect()
	}
}

#Preview { 
	ReplayViewController()
}
