//
//  CombiningOperators.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/8.
//

import Testing
import RxSwift

@Suite("组合运算符 连接组合可观察序列")
struct CombiningOperatorsTest {
    @Test("人为附加序列订阅时的起始状态 startWith") func startWith() {
        let numbers = Observable.of(2, 3, 4)
        let observable = numbers.startWith(1)
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
    }
    
    @Test("连接两个可观察序列 concat") func concat() {
        // 它订阅集合中的第一个序列依次传递其中的元素直到处理完然后处理下一个序列
		// 这个过程会重复进行直到集合中的所有 Observable 都被处理完毕
		// 如果在任何时候内部 Observable 抛出错误则连接的 Observable 也会抛出该错误并终止
        let first = Observable.of(1, 2, 3)
        let second = Observable.of(4, 5, 6)
        let observable = Observable.concat([first, second])
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
    }
    
    @Test("另一种连接两个可观察序列 concat") func concat2() {
        let germanCities = Observable.of("Berlin", "Munich", "Frankfurt")
        let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
        let observable = germanCities.concat(spanishCities)
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
    }
    
    @Test("concatMap") func concatMap() {
        let sequences = [
            "German cities": Observable.of("Berlin", "Munich", "Frankfurt"),
            "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
        ]
        
        let observable = Observable.of("German cities", "Spanish cities")
			.concatMap { counrty in 
				sequences[counrty] ?? .empty() 
			}
        
        _ = observable.subscribe(onNext: { string in
              print(string)
            })
		// 生成两个序列分别是德语和西班牙语的城市名称
		// 有一个序列会发出国家名称，每个国家名称又会映射到一个序列该序列会发出该国家的城市名称
		// 在开始考虑下一个国家之前输出给定国家的完整序列
    }
    
    @Test("合并 merge") func merge() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        let source = Observable.of(left.asObservable(), right.asObservable())
        let observable = source.merge()
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
		
		var leftValues = ["Berlin", "Munich", "Frankfurt"]
		var rightValues = ["Madrid", "Barcelona", "Valencia"]
		
		repeat {
			switch Bool.random() {
			case true where !leftValues.isEmpty:
				left.onNext("Left: " + leftValues.removeFirst())
			case false where !rightValues.isEmpty:
				right.onNext("Right: " + rightValues.removeFirst())
			default:
				break
			}
		} while !leftValues.isEmpty || !rightValues.isEmpty
		
		left.onCompleted()
		right.onCompleted()
		
		// 如果任何序列发出错误 merge() 观察对象立即传递该错误然后终止
		// merge(maxConcurrent:) 允许限制同时订阅的内部可观察序列的数量
	}
	
	@Test("合并首发事件并持续合并最新事件与另一个事件 combineLatest") func combineLatest() {
		let left = PublishSubject<String>()
		let right = PublishSubject<String>()
		let observable = Observable.combineLatest(left, right) { l, r in
			"\(l) \(r)"
		}
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
		
		print("> Sending a value to Left")
		left.onNext("Hello,")
		print("> Sending a value to Right")
		right.onNext("world")
		print("> Sending another value to Right")
		right.onNext("RxSwift")
		print("> Sending another value to Left")
		left.onNext("Have a good day,")

		left.onCompleted()
		right.onCompleted()
		// 在每个可观察对象都发出一个值之前什么都不会发生
		// 之后每当一个可观察对象发出新值时闭包都会接收每个可观察对象的最新值并产生结果
	}
	
	@Test("Zip") func zip() {
		enum Weather {
			case cloudy
			case sunny
		}
		
		let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
		let right: Observable<String> = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
		
		let observable = Observable.zip(left, right) { weather, city in
			"It's \(weather) in \(city)"
		}
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
	}
	
	@Test("触发器 withLatestFrom") func withLatestFrom() {
		let button = PublishSubject<Void>()
		let textField = PublishSubject<String>()
		
		let observable = button.withLatestFrom(textField)
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
		
		textField.onNext("Par")
		textField.onNext("Pari")
		button.onNext(())
		textField.onNext("Paris")
		button.onNext(())// 触发器触发获取最新值
		button.onNext(())
		
		// 适用于所有需要从可观察对象获取当前最新值但仅在特定触发器发生时才获取该值的情况
	}
	
	@Test("触发器 sample") func sample() {
		let button = PublishSubject<Void>()
		let textField = PublishSubject<String>()
		
		let observable = textField.sample(button)
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
		
		textField.onNext("Par")
		textField.onNext("Pari")
		textField.onNext("Paris")
		button.onNext(())
		button.onNext(())// 两次模拟点击按钮之间没有发出新值只会打印一次 Paris
		
		// 每次触发的可观察对象发出值时 sample(_:) 都会发出“另一个”可观察对象的最新值但前提是该值自上次触发以来已到达
		// 如果没有新数据到达 sample(_:) 则不会发出任何值
	}
	
	@Test("amb 优先选择") func amb() {
		let left = PublishSubject<String>()
		let right = PublishSubject<String>()
		
		let observable = left.amb(right)
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
		
		left.onNext("Lisbon")
		right.onNext("Copenhagen")
		left.onNext("London")
		left.onNext("Madrid")
		right.onNext("Vienna")
		left.onCompleted()
		right.onCompleted()
		// amb(_:) 订阅两个可观察对象并转发首先发出元素的可观察对象的元素
		// 它有一些特定的实际应用场景例如连接到冗余服务器并优先选择响应最快的服务器
	}
	
	@Test("switchLatest 切换到最新的可观察序列") func switchLatest() {
		let one = PublishSubject<String>()
		let two = PublishSubject<String>()
		let three = PublishSubject<String>()
		
		let source = PublishSubject<Observable<String>>()
		let observable = source.switchLatest()
		let disposable = observable.subscribe(onNext: { value in
			print(value)
		})

		source.onNext(one)
		one.onNext("Some text from sequence one")
		two.onNext("Some text from sequence two")
		
		source.onNext(two)
		two.onNext("More text from sequence two")
		one.onNext("and also from sequence one")
		
		source.onNext(three)
		two.onNext("Why don't you see me?")
		one.onNext("I'm alone, help me")
		three.onNext("Hey it's three. I win.")
		
		source.onNext(one)
		one.onNext("Nope. It's me, one!")
		
		disposable.dispose()
		
	}
	
	@Test("reduce 汇总值") func reduce() {
		let source = Observable.of(1, 3, 5, 7, 9)
		let observable = source.reduce(0) { summary, newValue in
			summary + newValue
		}
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
		
		// 该操作符会“累积”一个汇总值
		// 它从你提供的初始值开始,每次源可观察对象发出一个项时 reduce(_:_:) 都会调用你的闭包来生成一个新的汇总值
		// 当源可观察对象完成时它会发出汇总值然后自身也完成
	}
	
	@Test("scan 步加值") func scan() {
		let source = Observable.of(1, 3, 5, 7, 9)
		let observable = source.scan(0) { summary, newValue in
			summary + newValue
		}
		_ = observable.subscribe(onNext: { value in
			print(value)
		})
	}
	
	@Test("scan 步进值和当前值") func scan2() {
		let source = Observable.of(1, 3, 5, 7, 9)
		let scanObservable = source.scan(0, accumulator: +)
		let observable = Observable.zip(source, scanObservable)
		
		_ = observable.subscribe(onNext: { tuple in
			print("Value = \(tuple.0)   Running total = \(tuple.1)")
		})
	}

	@Test("scan 步进值和当前值") func scan3() {
		let source = Observable.of(1, 3, 5, 7, 9)
		let observable = source.scan((0, 0)) { acc, current in
			return (current, acc.1 + current)
		}
		
		_ = observable.subscribe(onNext: { tuple in
			print("Value = \(tuple.0)   Running total = \(tuple.1)")
		})
	}
}
