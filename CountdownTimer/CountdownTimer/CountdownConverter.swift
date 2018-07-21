//
//  CountdownConverter.swift
//  CountdownTimer
//
//  Created by 유금상 on 21/07/2018.
//  Copyright © 2018 유금상. All rights reserved.
//

import Foundation

class CountdownConverter {
    static func convert(_ seconds: Int) -> String {
        let hour: Int = seconds / 3600
        
        let secondsFromTime = hour * 3600
        let minuteSecond: Int = seconds - secondsFromTime
        
        let second: Int = minuteSecond % 60
        let minute: Int = minuteSecond / 60
        
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}
