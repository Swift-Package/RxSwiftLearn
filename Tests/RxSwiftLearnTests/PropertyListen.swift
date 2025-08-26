//
//  PropertyListen.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/7.
//

import Testing
import RxSwift

@Suite("6 属性监听")
struct PropertyListenTest {
    
    struct Student {
        let score: BehaviorSubject<Int>
    }

    @Test func flatMap() {
        let disposeBag = DisposeBag()
        
        let laura = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))
        
        let student = PublishSubject<Student>()
        
        student
            .flatMap { $0.score }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        student.onNext(laura)
        
        laura.score.onNext(85)
        
        student.onNext(charlotte)
        
        laura.score.onNext(95)
        
        charlotte.score.onNext(100)
    }
    
    @Test("flatMapLatest 您想要执行新的搜索并忽略上一个搜索的结果") func flatMapLastest() {
        let disposeBag = DisposeBag()
        
        let laura = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 90))
        
        let student = PublishSubject<Student>()
        
        student
            .flatMapLatest { $0.score }
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        
        student.onNext(laura)
        laura.score.onNext(85)
        student.onNext(charlotte)
        
        laura.score.onNext(95)
        charlotte.score.onNext(100)
    }
    
    @Test("materialize and dematerialize") func meterialize() {
        enum MyError: Error {
            case anError
        }
        
        let disposeBag = DisposeBag()
        
        let laura = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 100))
        
        let student = BehaviorSubject(value: laura)
        
        let studentScore = student
            .flatMapLatest { $0.score }
        
        studentScore
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        laura.score.onNext(85)
        laura.score.onError(MyError.anError)
        laura.score.onNext(90)
        
        student.onNext(charlotte)
    }
    
    @Test("materialize and dematerialize2") func meterialize2() {
        enum MyError: Error {
            case anError
        }
        
        let disposeBag = DisposeBag()
        
        let laura = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 100))
        
        let student = BehaviorSubject(value: laura)
        
        let studentScore = student
            .flatMapLatest { $0.score.materialize() }
        
        studentScore
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        laura.score.onNext(85)
        laura.score.onError(MyError.anError)
        laura.score.onNext(90)
        
        student.onNext(charlotte)
    }
    
    @Test("materialize and dematerialize3") func meterialize3() {
        enum MyError: Error {
            case anError
        }
        
        let disposeBag = DisposeBag()
        
        let laura = Student(score: BehaviorSubject(value: 80))
        let charlotte = Student(score: BehaviorSubject(value: 100))
        
        let student = BehaviorSubject(value: laura)
        
        let studentScore = student
            .flatMapLatest { $0.score.materialize() }
        
        studentScore
            .filter {
                guard $0.error == nil else {
                    print($0.error!)
                    return false
                }
                return true
            }
            .dematerialize()
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        laura.score.onNext(85)
        laura.score.onError(MyError.anError)
        laura.score.onNext(90)
        
        student.onNext(charlotte)
    }
}
