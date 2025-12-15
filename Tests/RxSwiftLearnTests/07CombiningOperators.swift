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
    @Test("序列订阅时的起始状态") func startWith() {
        let numbers = Observable.of(2, 3, 4)
        
        let observable = numbers.startWith(1)
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
    }
    
    @Test("连接两个可观察序列concat") func concat() {
        // 它订阅集合的第一个序列传递其元素直到完成，
        // 然后移动到下一个序列,直到集合中的所有可观察物都已使用
        // 如果在任何点上内部可观察物发出错误则连接的可观察物反过来会发出错误并终止
        let first = Observable.of(1, 2, 3)
        let second = Observable.of(4, 5, 6)
        
        let observable = Observable.concat([first, second])
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
    }
    
    @Test("另一种连接两个可观察序列concat") func concat2() {
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
            .concatMap { counrty in sequences[counrty] ?? .empty() }
        
        _ = observable.subscribe(onNext: { string in
              print(string)
            })
    }
    
    @Test("合并") func merge() {
        let left = PublishSubject<String>()
        let right = PublishSubject<String>()
        
        let source = Observable.of(left.asObservable(), right.asObservable())
        let observable = source.merge()
        _ = observable.subscribe(onNext: { value in
            print(value)
          })
    }
}
