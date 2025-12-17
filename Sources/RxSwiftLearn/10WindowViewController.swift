//
//  WindowViewController.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit
import SwiftUI
import RxSwift

// MARK: - 受控缓冲区
class WindowViewController: UIViewController {
	
	deinit {
		timer?.cancel()
		timer = nil
	}
	
	let disposeBag = DisposeBag()
	private var emittedCount = 0				// 用于给每个元素加序号
	private var timer: DispatchSourceTimer?		// 保持 timer 引用避免被释放
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("====== Window 示例开始 ======")
		
		let elementsPerSecond = 2				// 每秒发送 2 个元素
		let windowMaxCount = 10
		let windowTimeSpan: RxTimeInterval = .seconds(4)
		
		let sourceObservable = PublishSubject<String>()
		
		// 使用 GCD timer 定期发送元素并保存到 self.timer 保持存活
		timer = DispatchSource.makeTimerSource(queue: .main)
		timer?.schedule(deadline: .now(), repeating: 1.0 / Double(elementsPerSecond))
		timer?.setEventHandler { [weak self] in
			guard let self else { return }
			self.emittedCount += 1
			sourceObservable.onNext("🐱 \(self.emittedCount)")
		}
		timer?.resume()
		
		// 使用 window 将源切成按时间（4s）或按元素数（10）限制的窗口
		var windowIndex = 0
		sourceObservable
			.window(timeSpan: windowTimeSpan, count: windowMaxCount, scheduler: MainScheduler.instance)
			.subscribe(onNext: { window in
				let idx = windowIndex
				windowIndex += 1
				print("➡️ window \(idx) started")
				
				// 对每个窗口单独订阅：实时打印元素并在窗口完成时打印完成信息
				window.subscribe(
					onNext: { value in
						print("   window \(idx) item: \(value)")
					},
					onCompleted: {
						print("⬅️ window \(idx) completed")
					}
				).disposed(by: self.disposeBag)
			})
			.disposed(by: disposeBag)
		
		// 可选：在一段时间后停止发射
		DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
			self?.timer?.cancel()
			self?.timer = nil
			sourceObservable.onCompleted()
			print("Stopped timer and completed source")
		}
	}
}

#Preview {
	WindowViewController()
}
