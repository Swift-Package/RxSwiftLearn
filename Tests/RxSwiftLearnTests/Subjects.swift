//
//  Subjects.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/3.
//

import Testing
import RxSwift

enum MyError: Error {
    case anError
}

func print<T: CustomTestStringConvertible>(label: String, event: Event<T>) {
    print(label, (event.element ?? event.error) ?? event)
}

@Suite("2 Subject主题类型")
struct SubjectTest {
    @Test("PublishSubject 初始状态为空,仅向订阅者发送新元素,并且完成事件之后只会向新订阅者发送完成事件") func publishSubject() {
        let subject = PublishSubject<String>()
        
        subject.on(.next("Is anyone listening?"))
        
        let subscriptionOne = subject.subscribe { string in
            print(string)
        }
        
        subject.onNext("1")
        subject.onNext("2")
        
        let subscriptionTwo = subject.subscribe { event in
            print("2) ", event.element ?? event)
        }
        
        
        subject.onNext("3")
        
        subscriptionOne.dispose()
        
        subject.onNext("4")
        
        subject.onCompleted()
        
        subject.onNext("5")
        
        subscriptionTwo.dispose()
        
        let disposeBag = DisposeBag()
        
        subject.subscribe { event in
            print("3) ", event.element ?? event)
        }.disposed(by: disposeBag)
        
        subject.onNext("?")
    }
    
    @Test("BehaviorSubject 发送最新事件给新订阅者") func behaviorSubject() {
        let disposeBag = DisposeBag()
        let subject = BehaviorSubject(value: "初始值")
        
        subject.onNext("X")
        
        subject.subscribe {
            print(label: "1) ", event: $0)
        }.disposed(by: disposeBag)
        
        subject.onError(MyError.anError)
        
        subject.subscribe {
            print(label: "2) ", event: $0)
        }.disposed(by: disposeBag)
    }
    
    @Test("ReplaySubject 缓冲指定数量事件给新订阅者") func replaySubject() {
        let disposeBag = DisposeBag()
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.subscribe {
            print(label: "1) ", event: $0)
        }.disposed(by: disposeBag)
        
        subject.subscribe {
            print(label: "2) ", event: $0)
        }.disposed(by: disposeBag)
        
        subject.onNext("4")
        subject.onError(MyError.anError)
        // subject.dispose()// 通过事先在重播主题上明确调用 dispose(）新订阅者将只收到一个 error 事件表明主题已被处置
        
        subject.subscribe {
            print(label: "3) ", event: $0)
        }.disposed(by: disposeBag)
    }
}
