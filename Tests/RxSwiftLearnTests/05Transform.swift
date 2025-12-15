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

@Suite("变换运算符")
struct TransformTest {
	@Test("sharedInstance 副作用") func shared() {
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
	
	@Test func toArray() {
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C")
            .toArray()
            .subscribe { arr in
                print(arr)
            }.disposed(by: disposeBag)
    }
    
    @Test("Map") func map() {
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
}
