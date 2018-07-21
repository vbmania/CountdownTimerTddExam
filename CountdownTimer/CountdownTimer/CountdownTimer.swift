//
//  CountdownTimer.swift
//  CountdownTimer
//
//  Created by 유금상 on 21/07/2018.
//  Copyright © 2018 유금상. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


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
    
    func setDuration(duration: Int) {
        totalSeconds = duration
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
