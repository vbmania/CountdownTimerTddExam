//
//  ViewController.swift
//  CountdownTimer
//
//  Created by 유금상 on 2018. 6. 17..
//  Copyright © 2018년 유금상. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
//    let countdownTimer = CountdownTimer()

    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var timerToggleButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    @IBOutlet weak var timePicker: UIDatePicker!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        countdownTimer.timeChanged
//            .map { CountdownConverter.convert($0) }
//            .bind(to: self.timerLabel.rx.text)
//            .disposed(by: disposeBag)
//
//
//        countdownTimer.timeChanged
//            .subscribe(onNext: { [weak self] (remains) in
//                if remains < 11 {
//                    self?.view.backgroundColor = UIColor.red
//                } else {
//                    self?.view.backgroundColor = UIColor.black
//                }
//            })
//            .disposed(by: disposeBag)
//
//        countdownTimer.state.map { $0 == .started }
//            .bind(to: timerToggleButton.rx.isSelected)
//            .disposed(by: disposeBag)
//
//        timerToggleButton.rx.tap.subscribe(onNext: { [weak self] in
//            guard let timer = self?.countdownTimer else { return }
//            if timer.state.value == .started {
//                timer.stop()
//            } else {
//                timer.start()
//            }
//        })
//            .disposed(by: disposeBag)
//
//        countdownTimer.state.map { $0 == .stopped }
//            .bind(to: resetButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//        resetButton.rx.tap.subscribe(onNext: { [weak self] in
//            self?.countdownTimer.reset()
//        })
//            .disposed(by: disposeBag)
//
//        timePicker.rx.countDownDuration
//            .subscribe(onNext: { [weak self] (duration) in
//                self?.countdownTimer.setDuration(Int(duration))
//            })
//            .disposed(by: disposeBag)
//    }
    
    @IBAction func toggleTimePicker(_ sender: Any) {
        timePicker.isHidden = !timePicker.isHidden
        timePicker.backgroundColor = .white
    }
}

