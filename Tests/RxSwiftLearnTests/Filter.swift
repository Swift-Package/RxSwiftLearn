//
//  Filter.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/7.
//

import Foundation
import Testing
import RxSwift

@Suite("4 过滤操作符")
struct FilterTest {
    @Test("忽略元素只关心事件") func ignoreElements() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        
        strikes
            .ignoreElements()
            .subscribe { _ in
                print("等到完成事件")
            }.disposed(by: disposeBag)
        
        strikes.onNext("X")
        strikes.onNext("X")
        strikes.onNext("X")
        strikes.onCompleted()
    }

    @Test("elementAt") func elementAt() {
        let strikes = PublishSubject<String>()
        let disposeBag = DisposeBag()
        
        strikes
            .element(at: 2)// 一旦在提供的索引处发出元素订阅就会终止
            .subscribe { _ in
                print("elementAt")
            }.disposed(by: disposeBag)
        
        strikes.onNext("A")
        strikes.onNext("B")
        strikes.onNext("C")
    }
    
    @Test("skip") func skip() {
        let disposeBag = DisposeBag()
        
        Observable.of("A", "B", "C", "D", "E", "F")
            .skip(3)
            .subscribe { str in
                print(str)
            }.disposed(by: disposeBag)
    }
    
    @Test("skipWhile 跳过直到不满足后后续的就不拦截了") func skipWhile() {
        let disposeBag = DisposeBag()
        Observable.of(2, 2, 3, 4, 4)
            .skip(while: { $0.isMultiple(of: 2) } )
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    @Test("skipUntil 跳过直到另一个订阅发布") func skipUntil() {
        let disposeBag = DisposeBag()
        
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject
            .skip(until: trigger)
            .subscribe { str in
                print(str)
            }.disposed(by: disposeBag)
        
        
        subject.onNext("A")
        subject.onNext("B")
        
        trigger.onNext("X")
        subject.onNext("C")
        subject.onNext("D")
    }
    
    @Test("take") func take() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5, 6)
            .take(3)
            .subscribe { str in
                print(str)
            }.disposed(by: disposeBag)
    }
    
    @Test("takeWhile 只要条件满足就一直拿") func takeWhile() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 2, 4, 4, 6, 6)
            .enumerated()
            .take(while: { (index, element) in
                element.isMultiple(of: 2) && index < 3
            })
            .map(\.element)
            .subscribe(onNext: {
                  print($0)
            }).disposed(by: disposeBag)
    }
    
    @Test("takeUntil 一直拿到条件满足就停下") func takeUntil() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5)
            .take(until: { element in
                element.isMultiple(of: 4)
            }, behavior: .inclusive)// 满足条件的那个是否要拿
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    @Test("takeUntil 与另一个") func takeUntilTrigger() {
        let disposeBag = DisposeBag()
        
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject
            .take(until: trigger)
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        
        trigger.onNext("X")

        subject.onNext("3")
    }
    
    @Test("takeUntil 内存管理") func takeUntilMemonry() {
//        _ = someObservable
//            .takeUntil(self.rx.deallocated)
//            .subscribe(onNext: {
//                print($0)
//            })
    }
    
    @Test("distinctUntilChanged 去除重复元素") func distinctUntilChanged() {
        let disposeBag = DisposeBag()
        Observable.of("A", "A", "B", "B", "A")
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
    @Test("distinctUntilChanged ???还没搞懂先放着") func distinctUntilChanged2() {
        let disposeBag = DisposeBag()
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
            .distinctUntilChanged { a, b in
                guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                      let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
                
                var containsMatch = false
                
                for aWord in aWords where bWords.contains(aWord) {
                    containsMatch = true
                    break
                }
                return containsMatch
            }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
}
