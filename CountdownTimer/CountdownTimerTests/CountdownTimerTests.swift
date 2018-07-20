//
//  CountdownTimerTests.swift
//  CountdownTimerTests
//
//  Created by 유금상 on 2018. 6. 17..
//  Copyright © 2018년 유금상. All rights reserved.
//

// * 특정 시간을 셋팅할 수 있어야 한다.
// * 시간이 가는 동안 초단위로 표시할 수 있어야 한다.
// * 시간이 끝나면 끝났다는 것을 표시할 수 있어야 한다.
// * 시간을 중간에 멈추고, 이어서 시작하거나, 리셋할 수 있어야 한다.
//
//
// [v] 시간을 정할 수 있어야 한다.
// [v] 시간을 변경할 수 있어야 한다.

// [v] start 할 수 있어야 한다.
// [v] stop 할 수 있어야 한다.
// [v] reset 할 수 있다.

// [v] start (reset, stop)
// [v] stop (start)
// [v] reset (stop)
// [v] setTime (init, reset)

// [v] setTime 하면 화면에 그 시간이 표시되어야 한다.

// [v] start하면 시간의 변화를 알 수 있어야 한다.
// [v] 시간은 역순으로 카운트 다운 되어야 한다.

// [v] stop을 하면 시간의 변화가 멈춰야 한다.
// [] reset을 하면 남은 시간 표시가 초기화 되어야 한다.

// [] stop, start 하면 시간을 이어서 표시한다.

// [] 시간 출력 형식 00:00:00
// [X] 시간 입력을 TimeInerval로 변환해야 한다. -> 시간을 입력하면 UIDatePicker가 TimeInterval로 돌려준다.


import XCTest
import Nimble
import RxSwift
import RxCocoa

@testable import CountdownTimer

enum CountdownTimerState {
    case started
    case stopped
    case pending
}

@objcMembers
class CountdownTimer: NSObject {
    
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var totalSeconds: Int = 0
    var remainSeconds: Int = 0
    
    var state: BehaviorRelay<CountdownTimerState> = BehaviorRelay<CountdownTimerState>(value: .pending)
    let timeChanged: PublishSubject<Int> = PublishSubject<Int>()
    private let interval: Double
    private var timer: Disposable?
    
    var disposeBag = DisposeBag()
    
    init(interval: Double = 1) {
        self.interval = interval
        super.init()
        
        timeChanged.subscribe(onNext: { [weak self] (remain) in
            self?.remainSeconds = remain
        })
        .disposed(by: disposeBag)
    }
    
    func setTime(hour: Int, minute: Int, second: Int) {
        if state.value != .pending { return }
        self.hour = hour
        self.minute = minute
        self.second = second
        
        totalSeconds = hour * 3600 + minute * 60 + second
        timeChanged.onNext(totalSeconds)
    }
    
    func start() {
        if state.value != .started {
            state.accept(.started)
            timer?.dispose()
            
            let remainSeconds = self.remainSeconds - 1
            
            timer = Observable<Int>
                .interval(RxTimeInterval(interval), scheduler: MainScheduler.instance)
                .take(remainSeconds + 1)
                .map {remainSeconds - $0}
                .bind(to: timeChanged)
        }
    }
    
    func stop() {
        if state.value == .started {
            state.accept(.stopped)
            timer?.dispose()
        }
    }
    
    func reset() {
        if state.value == .stopped {
            state.accept(.pending)
            timeChanged.onNext(totalSeconds)
        }
    }
    
}

class CountdownTimerTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    
    override func setUp() {
        super.setUp()

    }
    
    
    func testCountdownTimer() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 0)
    }
    
    func testCanChangeTime() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 0)
        underTest.setTime(hour: 1, minute: 1, second: 1)
        
        expect(underTest.hour).to(equal(1))
        expect(underTest.minute).to(equal(1))
        expect(underTest.second).to(equal(1))
    }
    
    
    func testCanNotChangeTimeWhenStarted() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        underTest.setTime(hour: 2, minute: 2, second: 2)
        expect(underTest.hour).to(equal(0))
        expect(underTest.minute).to(equal(0))
        expect(underTest.second).to(equal(1))
    }
    
    func testCanNotChangeTimeWhenStopped() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        underTest.stop()
        underTest.setTime(hour: 2, minute: 2, second: 2)
        expect(underTest.hour).to(equal(0))
        expect(underTest.minute).to(equal(0))
        expect(underTest.second).to(equal(1))
    }
    
    func testCanChangeTimeWhenPending() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        underTest.stop()
        underTest.reset()
        underTest.setTime(hour: 2, minute: 2, second: 2)
        expect(underTest.hour).to(equal(2))
        expect(underTest.minute).to(equal(2))
        expect(underTest.second).to(equal(2))
    }
    
    
    func testCanStart() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        expect(underTest.state.value).to(equal(.started))
    }
    
    func testCanStartWhenStopped() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.stop()
        underTest.start()
        expect(underTest.state.value).to(equal(.started))
    }
    
    func testCanStartWhenReseted() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.reset()
        underTest.start()
        expect(underTest.state.value).to(equal(.started))
    }
    
    func testCanNotStartWhenAlreadyStarted() {
        let underTest = CountdownTimer()
        var emitCount: Int = 0
        
        underTest.setTime(hour: 0, minute: 0, second: 1)

        underTest.state.filter { $0 == .started } .subscribe(onNext: { (started) in
            emitCount = emitCount + 1
        })
        .disposed(by: disposeBag)

        underTest.start()
        underTest.start()
        
        expect(underTest.state.value).to(equal(.started))
        expect(emitCount).to(equal(1))
    
    }
    
    func testCanStopWhenStarted() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        underTest.stop()
        expect(underTest.state.value).to(equal(.stopped))
    }
    
    func testCanNotStopWhenReseted() {
        let underTest = CountdownTimer()
        underTest.reset()
        underTest.stop()
        expect(underTest.state.value).toNot(equal(.stopped))
    }
    
    func testCanNotStopWhenAlreadyStopped() {
        let underTest = CountdownTimer()
        var emitCount: Int = 0
        
        underTest.setTime(hour: 0, minute: 0, second: 1)
        
        underTest.start()
        
        underTest.state.filter { $0 == .stopped }.subscribe(onNext: { (stopped) in
          emitCount = emitCount + 1
        })
        .disposed(by: disposeBag)
        
        
        underTest.stop()
        underTest.stop()
        
        expect(emitCount).to(equal(1))
    }
    
    func testCanReset() {
        let underTest = CountdownTimer()
        underTest.reset()
    }
    
    func testCanResetWhenStopped() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        underTest.stop()
        underTest.reset()
        expect(underTest.state.value).to(equal(.pending))
    }
    
    func testCanNotResetWhenNotStopped() {
        let underTest = CountdownTimer()
        underTest.reset()
        expect(underTest.state.value).to(equal(.pending))
    }
    
    
    func testCanNotResetWhenWasReset() {
        let underTest = CountdownTimer()

        var emitCount: Int = 0
        underTest.setTime(hour: 0, minute: 0, second: 1)
        underTest.start()
        expect(underTest.state.value).to(equal(.started))
        
        underTest.stop()
        expect(underTest.state.value).to(equal(.stopped))
        
        
        underTest.state.filter { $0 == .pending }.subscribe(onNext: { (stopped) in
            emitCount = emitCount + 1
        })
        .disposed(by: disposeBag)

        underTest.reset()
        expect(underTest.state.value).to(equal(.pending))
        expect(emitCount).to(equal(1))
        
        underTest.reset()
        expect(underTest.state.value).to(equal(.pending))
        expect(emitCount).to(equal(1))
    }
    
    
    func testCanShowRemainningTimeWhenSettingTime() {
        let underTest = CountdownTimer()
        var emitCount: Int = 0
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            emitCount = emitCount + 1
        })
        .disposed(by: disposeBag)
        
        underTest.setTime(hour: 0, minute: 0, second: 0)
        
        expect(emitCount).to(equal(1))
    }
    
    
    func testCanShowRemainningTimeWhenSettingTime_0_0_1() {
        let underTest = CountdownTimer()
        var emitCount: Int = 0
        var result: Int = 0
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            emitCount = emitCount + 1
            result = remain
        })
        .disposed(by: disposeBag)
        
        underTest.setTime(hour: 0, minute: 0, second: 1)
        
        expect(emitCount).to(equal(1))
        expect(result).to(equal(1))
    }
    
    func testCanShowRemainningTimeWhenSettingTime_0_1_1() {
        let underTest = CountdownTimer()
        var emitCount: Int = 0
        var result: Int = 0
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            emitCount = emitCount + 1
            result = remain
        })
            .disposed(by: disposeBag)
        
        underTest.setTime(hour: 0, minute: 1, second: 1)
        
        expect(emitCount).to(equal(1))
        expect(result).to(equal(61))
    }
    
    
    func testCanShowRemainningTimeWhenSettingTime_1_1_1() {
        let underTest = CountdownTimer()
        var emitCount: Int = 0
        var result: Int = 0
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            emitCount = emitCount + 1
            result = remain
        })
            .disposed(by: disposeBag)
        
        underTest.setTime(hour: 1, minute: 1, second: 1)
        
        expect(emitCount).to(equal(1))
        expect(result).to(equal(3661))
    }
    
    
    func testCanShowRemainningTimeWhenSettingTime_0_0_3() {
        let underTest = CountdownTimer(interval: 0.1)

        let expectedResult = [3, 2, 1, 0]
        var result: [Int] = [Int]()
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            result.append(remain)
        })
        .disposed(by: disposeBag)
        
        underTest.setTime(hour: 0, minute: 0, second: 3)
        underTest.start()
        
        expect(result).toEventually(equal(expectedResult), timeout: 0.5)
    }
    
    
    func testCanStopTimer() {
        let underTest = CountdownTimer(interval: 0.1)
        
        let expectation = XCTestExpectation()
        
        var result: [Int] = [3, 2, 1, 0]
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            result.remove(at: 0)
            
            if result.count < 1 {
                XCTFail("카운팅 갯수 초과 \(result.count)")
                expectation.fulfill()
            }
        })
        .disposed(by: disposeBag)
        
        underTest.setTime(hour: 0, minute: 0, second: 3)
        underTest.perform(#selector(underTest.stop), with: nil, afterDelay: 0.3)
        expectation.perform(#selector(expectation.fulfill), with: nil, afterDelay: 0.4)
        underTest.start()
        
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    
    func testCanResetTimer() {
        let underTest = CountdownTimer(interval: 0.1)
        
        var result: [Int] = [Int]()
        let expectionResult = [10, 9, 8, 7, 10]
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            result.append(remain)
        })
         .disposed(by: disposeBag)

        
        
        underTest.setTime(hour: 0, minute: 0, second: 10)
        underTest.perform(#selector(underTest.stop), with: nil, afterDelay: 0.4)
        underTest.perform(#selector(underTest.reset), with: nil, afterDelay: 0.6)
        
        underTest.start()
        
        expect(result).toEventually(equal(expectionResult), timeout: 1)
    }
    
    
    func testCanResumeTimer() {
        let underTest = CountdownTimer(interval: 0.1)
        
        var result: [Int] = [Int]()
        let expectionResult = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        
        underTest.timeChanged.subscribe(onNext: { (remain) in
            result.append(remain)
        })
            .disposed(by: disposeBag)
        
        
        
        underTest.setTime(hour: 0, minute: 0, second: 10)
        underTest.perform(#selector(underTest.stop), with: nil, afterDelay: 0.4)
        underTest.perform(#selector(underTest.start), with: nil, afterDelay: 0.6)
        
        underTest.start()
        
        expect(result).toEventually(equal(expectionResult), timeout: 1.5)
    }
    
    
}
