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
// [] 시간을 정할 수 있어야 한다.
// [] 시간을 변경할 수 있어야 한다.

// [] start 할 수 있어야 한다.
// [] stop 할 수 있어야 한다.
// [] reset 할 수 있다.

// [] start (reset, stop)
// [] stop (start)
// [] reset (stop)
// [] setTime (init, reset)

// [] setTime 하면 화면에 그 시간이 표시되어야 한다.

// [] start하면 시간의 변화를 알 수 있어야 한다.
// [] 시간은 역순으로 카운트 다운 되어야 한다.

// [] stop을 하면 시간의 변화가 멈춰야 한다.
// [] reset을 하면 남은 시간 표시가 초기화 되어야 한다.

// [] stop, start 하면 시간을 이어서 표시한다.

// [] 시간 출력 형식 00:00:00
// [X] 시간 입력을 TimeInerval로 변환해야 한다. -> 시간을 입력하면 UIDatePicker가 TimeInterval로 돌려준다.


import XCTest
@testable import CountdownTimer

class CountdownTimerTests: XCTestCase {
    
    func testCanSetTime() {
        let underTest = CountdownTimer()
        underTest.setTime(hour: 0, minute: 0, second: 0)
    
    }
    
}
