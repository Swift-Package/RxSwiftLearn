//
//  Relays.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/6.
//

import Testing
import RxSwift
import RxRelay

@Suite("3 常用的Relay 是对其他 Subject 的封装,永远不会终止")
struct RelaysTest {
    @Test("PublishRelay") func publishRelay() {
        let disposeBag = DisposeBag()
        let relay = PublishRelay<String>()
        
        relay.accept("Knock knock, anyone home?")
        
        relay.subscribe { str in
            print(str)
        }.disposed(by: disposeBag)
        
        relay.accept("1")
    }

    @Test("BehaviorRelay") func behaviorRelay() {
        let disposeBag = DisposeBag()
        let relay = BehaviorRelay.init(value: "初始值")
        
        relay.accept("new")
        
        relay.subscribe {
            print(label: "1)", event: $0)
        }.disposed(by: disposeBag)
        
        relay.accept("1")
        
        relay.subscribe {
            print(label: "2)", event: $0)
        }.disposed(by: disposeBag)
        
        relay.accept("2")
        
        print(relay.value)
    }
}
