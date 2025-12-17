//
//  BufferViewController.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit
import SwiftUI
import RxSwift

// MARK: - 受控缓冲区
class BufferViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let bufferMaxCount = 2
		let bufferTimeSpan: RxTimeInterval = .seconds(4)
		
		let sourceObserable = PublishSubject<String>()
		sourceObserable.buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance)
			.subscribe { str in
				print(str)
			}
			.disposed(by: disposeBag)
		
		// buffer 的行为
		// •	内部维护一个数组 [String]
		// •	满足任意条件就 emit：
		// 		•	数量达到 count = 2
		// 		•	时间达到 4 秒
		// •	emit 后清空 buffer 重新开始
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
			sourceObserable.onNext("🐱")
			sourceObserable.onNext("🐱")
			sourceObserable.onNext("🐱")
		}
		
		// 打印结果
		// next([])
		// next(["🐱", "🐱"])
		// next(["🐱"])
		// next([])
		// next([])
	}
}

#Preview { 
	BufferViewController()
}
