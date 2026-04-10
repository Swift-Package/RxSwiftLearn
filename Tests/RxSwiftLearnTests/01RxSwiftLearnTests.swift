import Foundation
import UIKit
import Testing
import RxSwift
import RxCocoa
@testable import RxSwiftLearn

@Suite("01入门指南")
struct RxSwiftLearn {
    @Test("Just Of From")
	func justOfFrom() {
		var array = [10, 20, 30]
		for number in array {
			print(number)
			array = [40, 50, 60]
		}
		print(array)
		
        let one = 1
        let two = 2
        let three = 3
		
		print("--Just--")
		let just = Observable<Int>.just(one)
		_ = just.subscribe { event in
			if let element = event.element {
				print(element)
			}
		}
        
		print("--Of--")
		let of = Observable.of(one, two, three)
        _ = of.subscribe { event in
            if let element = event.element {
                print(element)
            }
        }
		
		print("--Of1--")
		let of1 = Observable.of([one, two, three])
		_ = of1.subscribe { event in
			if let element = event.element {
				print(element)
			}
		}
		
		print("--From--")
		let from = Observable.from([one, two, three])
		_ = from.subscribe { event in
			if let element = event.element {
				print(element)
			}
		}
    }
	
    @Test("Empty 只会发出一个 completed 事件的空可观察序列")
	func empty() {
        let observable = Observable<Void>.empty()
        _ = observable
            .subscribe(onNext: { element in
                print(element)
            }, onCompleted: {
                print("Completed")
            }
        )
    }
	
    @Test("Never 不发出任何东西且永不终止的可观察物")
	func never() {
        let observable = Observable<Void>.never()
        _ = observable
            .subscribe(onNext: { element in
                print(element)
            }, onCompleted: {
                print("Completed")
            })
    }
	
    @Test("Range 生成特定范围的可观察序列")
	func range() {
        let observable = Observable<Int>.range(start: 1, count: 10)
        _ = observable.subscribe(onNext: { i in
                print(i)
            })
    }
	
    @Test("DisposeBag")
	func dispose() {
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C")
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
	
    @Test("Creat 定义所有将发送给订阅者的事件")
	func create() {
        let disposeBag = DisposeBag()
		let x = Observable<String>.create { observer in
            observer.onNext("1")
            observer.onCompleted()
            observer.onNext("?")
            return Disposables.create()// 返回一个可释放对象，定义当可观察对象终止或被释放时会发生什么,在这种情况下不需要清理因此返回一个空的可释放对象
        }
		
		x
			.subscribe(
				onNext: { print($0) },
				onError: { print($0) },
				onCompleted: { print("Completed") },
				onDisposed: { print("Disposed") }
			)
			.disposed(by: disposeBag)
    }
	
    @Test("订阅工厂")
	func factoryDeferred() {
        let disposeBag = DisposeBag()
        var flip = false
        let factory: Observable<Int> = Observable.deferred {// deferred 推迟
            flip.toggle()
            if flip {
                return Observable.of(1, 2, 3)
            } else {
                return Observable.of(4, 5, 6)
            }
        }
        for _ in 0...3 {
            factory.subscribe(onNext: {
                print($0, terminator: "")
            })
            .disposed(by: disposeBag)
			print()
        }
    }
	
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
	
	// MARK: - Trait 特化对象
	// Single 		-> success(value) / error(Error)
	// Maybe		-> success(value) / completed / error(Error)
	// Completable 	-> completed / error(Error)
    struct TraitsSequence {
		// MARK: - 加载文本文件内容并作为 Single 序列发出
        func loadText(from name: String) -> Single<String> {
            return Single.create { single in
                let disposable = Disposables.create()
                guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                    // single(.error(FileReadError.fileNotFound))
                    return disposable
                }
                
                guard let data = FileManager.default.contents(atPath: path) else {
                    // single(.error(FileReadError.unreadable))
                    return disposable
                }
                
                guard let contents = String(data: data, encoding: .utf8) else {
                    // single(.error(FileReadError.encodingFailed))
                    return disposable
                }
                
                single(.success(contents))
                return disposable
            }
        }
    }
	
	@Test("Never 不发出任何东西且永不终止的可观察物")
	func never2() {
		let disposeBag = DisposeBag()
		let observable = Observable<Any>.never()
		observable.do(onSubscribe: {
			print("Subscribed")
		})
		.subscribe(onNext: { element in
			print(element)
		},
				   onCompleted: {
			print("Completed")
		},
				   onDisposed: {
			print("Disposed")
		}).disposed(by: disposeBag)
	}
}
