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
    
    let blackView = UIView()
    
    var visualTimer    = Timer()
    var isRunning      = false
    
    var totalSeconds: TimeInterval = 0
    
    var minutes: Int   = 0
    var seconds: Int   = 0
    var fractions: Int = 0
    
    var mutableStopwatchStr = NSMutableAttributedString()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTimerColor()
    }
    
    func setupTimerColor() {
        let random = CGFloat(arc4random_uniform(255))
        
        var colors: [CGFloat] = [0, 255, random]
        colors.shuffle()
        
        let r = colors[0] / 255
        let g = colors[1] / 255
        let b = colors[2] / 255
        
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
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
        
        changeTimerColor()
        
        if isRunning == false {
            startVisualTimer()
            
            scrambleLbl.isHidden = true

        } else {
            stopTimer()
            
            timesGlobal.append(totalSeconds)
            scrambleLbl.isHidden = false
        }
    }
    
    func changeTimerColor() {
            
        let random = CGFloat(arc4random_uniform(255))
            
        var colors: [CGFloat] = [0, 255, random]
            
        colors.shuffle()
            
        let r = colors[0] / 255
        let g = colors[1] / 255
        let b = colors[2] / 255
            
        let randomColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 1, alpha: 0.6)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStopwatch)))
            blackView.alpha = 0
            
            view.addSubview(blackView)
            view.bringSubview(toFront: timeLbl)
        
        if isRunning == true {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.view.backgroundColor = randomColor
                self.blackView.alpha = 0
            }, completion: nil)

        } else {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {

                self.blackView.alpha = 1
            }, completion: nil)
        }
        
    
        }
    }
    
    func dismissHalfBlack() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
        }, completion: nil)
    }
    
    func fadeToRandomColor(_ color: UIColor, animation: UIViewAnimationOptions) {
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: animation, animations: {
            self.view.backgroundColor = color
        }, completion: nil)
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
        
        stopwatchStr.remove(at: stopwatchStr.index(before: stopwatchStr.endIndex))
        
        mutableStopwatchStr = NSMutableAttributedString(
            string: stopwatchStr,
            attributes: [NSFontAttributeName:UIFont(
                name: "AvenirNext-Regular",
                size: 90)!])
        
        mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 0))
        
        setupTimeLblFontSize()
        
        if totalSeconds == 3600 {
            visualTimer.invalidate()
        }
        
        timeLbl.attributedText = mutableStopwatchStr
        
        
    }
    
    func setupTimeLblFontSize() {
        if totalSeconds < 10 {
            //0.00 to 9.99
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 1))

        } else if totalSeconds < 60 {
            //10.00 to 59.99
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 2))

        } else if totalSeconds < 600 {
            //1:00.0 to 9:59.9
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 1))

        } else if totalSeconds >= 600 {
            //10:00.0 to 59:59.99
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 2))
        }
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
