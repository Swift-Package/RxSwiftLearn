//
//  Transform.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/7.
//

import Foundation
import Testing
import RxSwift

nonisolated(unsafe) var start = 0
func getStartNumber() -> Int {
	start += 1
	return start
}

@Suite("05变换运算符")
struct TransformTest {
	@Test("sharedInstance 副作用")
	func shared() {
		let disposeBag = DisposeBag()
		let numbers = Observable<Int>.create { observer in
			let start = getStartNumber()
			observer.onNext(start)
			observer.onNext(start + 1)
			observer.onNext(start + 2)
			observer.onCompleted()
			return Disposables.create()
		}
		
		numbers
			.subscribe(onNext: { el in
					print("element [\(el)]")
			}, onCompleted: {
				print("-------------")
			})
			.disposed(by: disposeBag)
		
		numbers
			.subscribe(onNext: { el in
				print("element [\(el)]")
			}, onCompleted: {
				print("-------------")
			})
			.disposed(by: disposeBag)
	}
	
	@Test("当可观察对象完成时该操作符会将一个元素序列转换为一个包含这些元素的数组")
	func toArray() {
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C")
            .toArray()
            .subscribe { arr in
                print(arr)
            }.disposed(by: disposeBag)
    }
    
    @Test("Map")
	func map() {
        let disposeBag = DisposeBag()
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        Observable<Int>.of(123, 4, 56)
          .map {
            formatter.string(for: $0) ?? ""
          }
          .subscribe(onNext: {
            print($0)
          })
          .disposed(by: disposeBag)
    }
	
	@Test("compactMap 如果映射后结果为 nil 则不保留")
	func compactMap() {
		let disposeBag = DisposeBag()
		Observable.of("To", "be", nil, "or", "not", "to", "be", nil)
			.compactMap { $0 }
			.toArray()
			.map { strings in
				strings.joined(separator: " ")
			}
			.subscribe { str in
				print(str)
			}.disposed(by: disposeBag)
	}
}
