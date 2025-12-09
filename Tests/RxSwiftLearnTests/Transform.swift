//
//  Transform.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/7.
//

import Foundation
import Testing
import RxSwift

@Suite("5 变换运算符")
struct TransformTest {
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
