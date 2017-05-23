//
//  TimerVC.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-19.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var scrambleLbl: UILabel!
    
    var visualTimer    = Timer()
    var isRunning      = false
    
    var totalSeconds: TimeInterval = 0
    
    var minutes: Int   = 0
    var seconds: Int   = 0
    var fractions: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        createScreen()
        
    }
    
    func createScreen() {
        let screen = UIView()
        screen.frame = view.frame
        screen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStopwatch)))
        
        view.addSubview(screen)
    }
    
    func handleStopwatch() {
        if isRunning == false {
            startVisualTimer()
            scrambleLbl.isHidden = true
            
        } else {
            stopTimer()
            timesGlobal.append(totalSeconds)
            scrambleLbl.isHidden = false
            
        }
    }
    
    func startVisualTimer() {
        minutes      = 0
        seconds      = 0
        fractions    = 0
        totalSeconds = 0
        
        visualTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stopTimer() {
        visualTimer.invalidate() //stop
        isRunning = false
        scrambleLbl.text = scrambleMoves(21)
    }
    
    func updateTimer() {
        
        fractions += 1
        
        totalSeconds += 0.01
        
        if fractions == 100 {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        
        let fractionsStr      = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsStr        = seconds > 9 ? "\(seconds)" : "\(seconds)"
        let secondsStrWith0   = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesStr        = minutes > 9 ? "\(minutes)" : "\(minutes)"
        
        var stopwatchStr = "\(secondsStr).\(fractionsStr)"
        
        if minutesStr != "0" {
            stopwatchStr = "\(minutesStr):\(secondsStrWith0).\(fractionsStr)"
        }
        
        let mutableStopwatchStr = NSMutableAttributedString(
            string: stopwatchStr,
            attributes: [NSFontAttributeName:UIFont(
                name: "AvenirNext-Regular",
                size: 90)!])
        
        mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 0))
        
        if totalSeconds < 10 {
            //0.00 to 9.99
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 1))
            mutableStopwatchStr.replaceCharacters(in: NSRange(location: 3, length: 1), with: "")
        } else if totalSeconds < 60 {
            //10.00 to 59.99
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 2))
            mutableStopwatchStr.replaceCharacters(in: NSRange(location: 4, length: 1), with: "")
        } else if totalSeconds < 600 {
            //1:00.30 to 9:59
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 1))
            mutableStopwatchStr.replaceCharacters(in: NSRange(location: 6, length: 1), with: "")
        } else if totalSeconds >= 600 {
            
            //10:00.34 to 59:59
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 0))
            mutableStopwatchStr.replaceCharacters(in: NSRange(location: 7, length: 1), with: "")
        }
        
        timeLbl.attributedText = mutableStopwatchStr
        
    }
    
    
    func scrambleMoves(_ length: Int) -> String {
        let moves          = ["B", "D", "F", "L", "R", "U"]
        let movesAdd       = ["", "'", "2", "2"]
        
        var movesScrambled = [String]()
        
        var lastIndex: Int? = nil
        
        repeat {
            let i  = Int(arc4random_uniform(UInt32(moves.count)))
            let i2 = Int(arc4random_uniform(UInt32(movesAdd.count)))
            
            guard i != lastIndex else {
                continue
            }
            
            lastIndex = i
            
            movesScrambled.append(moves[i] + movesAdd[i2])
            
        } while movesScrambled.count < length
        
        let movesScrambledJoined = movesScrambled.joined(separator: "  ")
        
        return movesScrambledJoined
    }

}
