//
//  TimerVC.swift
//  Cube Timer
//
//  Created by Erik on 2017-05-19.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class TimerVC: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var scrambleLbl: UILabel!
    
    let blackView = UIView()
    
    var scrambleStr = ""
    
    var visualTimer    = Timer()
    var isRunning      = false
    
    var totalSeconds: TimeInterval = 0
    
    var minutes: Int   = 0
    var seconds: Int   = 0
    var fractions: Int = 0
    var fractionsStr   = ""
    
    var stopwatchStr        = ""
    
    var mutableStopwatchStr = NSMutableAttributedString()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTimerColor()
    }
    
    func setupTimerColor() {
        let random = CGFloat(arc4random_uniform(255))
        
        var colors: [CGFloat] = [0, 255, random]
        colors.shuffle()
        
        view.backgroundColor = UIColor(red: colors[0]/255, green: colors[1]/255, blue: colors[2]/255, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrambleLbl.text = scrambleMoves(21)
        
        createScreen()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("Memory warning!")
    }
    
    func createScreen() {
        let screen = UIView()
        screen.frame = view.frame
        screen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStopwatch)))
        
        view.addSubview(screen)
    }
    
    func handleStopwatch() {
        
    
        handleColorAndDecimals()
        
        if isRunning == false {
            startVisualTimer()
                
            scrambleLbl.isHidden = true

        } else {
            stopTimer()
            saveTime()
            
            scrambleLbl.isHidden = false
        }
    }
    
    func saveTime() {
        var savedTimeRounded = String(Double(round(100*totalSeconds))/100)
        
        let savedTimeDouble = Double(savedTimeRounded)!
        
        if savedTimeDouble > 60.0 {
            let seconds = savedTimeDouble.truncatingRemainder(dividingBy: 60)
            let secondsRounded = Double(round(100*seconds)/100)
            let minutes: Int? = Int((savedTimeDouble / 60).truncatingRemainder(dividingBy: 60))
            
            savedTimeRounded = "\(minutes!):\(secondsRounded)"
            
            if minutes != nil {
                if seconds < 10.0 {
                    savedTimeRounded = "\(minutes!):0\(secondsRounded)"
                }
            }
        }
        
        //If time is e.g 1:48.2 or 18.7, add a 0 at the end.
        if let decimals = savedTimeRounded.components(separatedBy: ".").last {
            if decimals.characters.count < 2 {
                savedTimeRounded.append("0")
            }
        }
        
        timesModel.append(totalSeconds)
        timesGlobal.insert(savedTimeRounded, at: 0)
        UserDefaults.standard.set(timesGlobal, forKey: Key.times)
        
        let dateAndTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        formatter.timeZone   = TimeZone.current
        
        let date = formatter.string(from: dateAndTime)
        
        formatter.dateFormat = "HH:MM"
        let time = formatter.string(from: dateAndTime)
        
        print("-------------------")
        print(date)
        print("-------------------")
        print(time)
        print("-------------------")
        print(scrambleStr)
    }
    
    func handleColorAndDecimals() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 1, alpha: 0.6)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStopwatch)))
            blackView.alpha = 0
            
            view.addSubview(blackView)
            view.bringSubview(toFront: timeLbl)
        
        if isRunning == true {
            view.backgroundColor = UIColor.randomized()
            blackView.alpha = 0
            
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
        
        scrambleStr  = scrambleLbl.text!
        
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
        
        
        fractionsStr      = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsStr        = seconds > 9 ? "\(seconds)" : "\(seconds)"
        let secondsStrWith0   = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesStr        = minutes > 9 ? "\(minutes)" : "\(minutes)"
        
        stopwatchStr = "\(secondsStr).\(fractionsStr)"
        
        if minutesStr != "0" {
            stopwatchStr = "\(minutesStr):\(secondsStrWith0).\(fractionsStr)"
        }
        
        mutableStopwatchStr = NSMutableAttributedString(
            string: stopwatchStr,
            attributes: [NSFontAttributeName:UIFont(
                name: "AvenirNext-Regular",
                size: 90)!])
        
        mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 0, length: 0))
        
        setupTimeLblFontSize()
        
        if totalSeconds == 3600 {
            stopTimer()
            saveTime()
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
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 150)!, range: NSRange(location: 2, length: 2))
        } else if totalSeconds >= 600 {
            //10:00.0 to 59:59.99
            mutableStopwatchStr.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 90)!, range: NSRange(location: 0, length: 7))
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
