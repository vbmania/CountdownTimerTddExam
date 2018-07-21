//
//  CountdownConverterTests.swift
//  CountdownTimerTests
//
//  Created by 유금상 on 13/07/2018.
//  Copyright © 2018 유금상. All rights reserved.
//

// [] 시간은 시/분/초가 구분되어 출력되어야 한다.
//  [V] 0초
//  [V] 1초
//  [V] 3초
//  [V] 59초
//  [V] 60초
//  [V] 61초
//  [V] 3599초
//  [V] 3600초
//  [V] 3601초
//  [] 3661초

import XCTest
import Nimble

class CountdownConverterTests: XCTestCase {
    
    func testConvertSecondsToDisplay_0() {
        
        let result: String = CountdownConverter.convert(0)
        expect(result).to(equal("00:00:00"))
    }
    
    func testConvertSecondsToDisplay_1() {
        
        let result: String = CountdownConverter.convert(1)
        expect(result).to(equal("00:00:01"))
    }
    
    func testConvertSecondsToDisplay_3() {
        
        let result: String = CountdownConverter.convert(3)
        expect(result).to(equal("00:00:03"))
    }
    
    func testConvertSecondsToDisplay_59() {
        
        let result: String = CountdownConverter.convert(59)
        expect(result).to(equal("00:00:59"))
    }
    
    func testConvertSecondsToDisplay_60() {
        
        let result: String = CountdownConverter.convert(60)
        expect(result).to(equal("00:01:00"))
    }
    
    func testConvertSecondsToDisplay_61() {
        
        let result: String = CountdownConverter.convert(61)
        expect(result).to(equal("00:01:01"))
    }
    
    func testConvertSecondsToDisplay_3599() {
        
        let result: String = CountdownConverter.convert(3599)
        expect(result).to(equal("00:59:59"))
    }
    
    func testConvertSecondsToDisplay_3600() {
        
        let result: String = CountdownConverter.convert(3600)
        expect(result).to(equal("01:00:00"))
    }
    
    func testConvertSecondsToDisplay_3601() {
        
        let result: String = CountdownConverter.convert(3601)
        expect(result).to(equal("01:00:01"))
    }
    
    func testConvertSecondsToDisplay_3661() {
        
        let result: String = CountdownConverter.convert(3661)
        expect(result).to(equal("01:01:01"))
    }
    
}
