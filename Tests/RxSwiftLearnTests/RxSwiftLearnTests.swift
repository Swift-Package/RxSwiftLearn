import Foundation
import UIKit
import Testing
import RxSwift
import RxCocoa
@testable import RxSwiftLearn

@Suite("1 入门指南")
struct RxSwiftLearn {
    @Test("Observable") func example() {
		var array = [10, 20, 30]
		for number in array {
			print(number)
			array = [40, 50, 60]
		}
		print(array)
		
		
        let one = 1
        let two = 2
        let three = 3
        
        let observable = Observable.of(one, two, three)
        _ = observable.subscribe { event in
            if let element = event.element {
                print(element)
            }
        }
    }

    @Test("只会发出一个completed事件的空可观察序列") func empty() {
        let observable = Observable<Void>.empty()
        _ = observable
            .subscribe(onNext: { element in
                print(element)
            }, onCompleted: {
                print("Completed")
            }
        )
    }

    @Test("不发出任何东西且永不终止的可观察物") func never() {
        let observable = Observable<Void>.never()
        _ = observable
            .subscribe(onNext: { element in
                print(element)
            }, onCompleted: {
                print("Completed")
            })
    }

    @Test("不发出任何东西且永不终止的可观察物") func never2() {
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

    @Test("生成特定范围的可观察序列") func range() {
        let observable = Observable<Int>.range(start: 1, count: 10)
        _ = observable.subscribe(onNext: { i in
                print(i)
            })
    }

    @Test("DisposeBag") func dispose() {
        let disposeBag = DisposeBag()
        Observable.of("A", "B", "C")
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }

    @Test("creat") func create() {
        let disposeBag = DisposeBag()
        Observable<String>.create { observer in
            observer.onNext("1")
            observer.onCompleted()
            observer.onNext("?")
            return Disposables.create()
        }.subscribe(
            onNext: { print($0) },
            onError: { print($0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        )
        .disposed(by: disposeBag)
    }

    @Test("订阅工厂") func factory() {
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
        }
    }

    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }

    @Suite("特征序列")
    struct TraitsSequence {
        @Test("Single") func single() {
            
        }
        
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
}
