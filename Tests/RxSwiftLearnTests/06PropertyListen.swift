//
//  PropertyListen.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/1/7.
//

import Testing
import RxSwift
import RxRelay

@Suite("属性监听")
struct PropertyListenTest {
    
    struct Student {
        let score: BehaviorSubject<Int>
    }

    @Test("flatMap 持续多跟踪对象") func flatMap() {
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
        
        laura.score.onNext(95)// 为什么这里也会触发监听的打印: 因为 flatMap 会跟踪它创建的每一个可观察对象,每个添加到源可观察对象上的元素都会创建一个可观察对象
        
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
        
        laura.score.onNext(95)// 这个不会触发订阅了
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
            .flatMapLatest { $0.score.materialize() }// materialize 将其转换成 Event 事件发送
        
        studentScore
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
        
        laura.score.onNext(85)
        laura.score.onError(MyError.anError)
		
        laura.score.onNext(90)// 这个失效
        
        student.onNext(charlotte)
		charlotte.score.onNext(105)
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
            .filter {// 过滤掉错误事件
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
		charlotte.score.onNext(105)
    }
}
