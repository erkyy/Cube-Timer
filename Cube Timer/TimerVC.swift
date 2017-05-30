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
    
    var isGreen = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTimerColor()
    }
    
    func setupTimerColor() {
        self.view.backgroundColor = UIColor.randomized()
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
        
        let customGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleStopwatch(sender:)))
        customGesture.minimumPressDuration = 0
        screen.addGestureRecognizer(customGesture)
        
        view.addSubview(screen)
    }
    
    private var markAsGreenWorkItem: DispatchWorkItem? {
        didSet {
            oldValue?.cancel() //cancel old value when a new value is set (or old value is nilled)
        }
    }
    
    func handleStopwatch(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            timeLbl.textColor = .red
            isGreen = false
            
            scrambleLbl.isHidden = true
            let workItem = DispatchWorkItem {
                self.timeLbl.textColor = .green
                self.isGreen = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
            markAsGreenWorkItem = workItem
            
        case .possible, .changed:
            break //no action needed
        case .cancelled, .ended, .failed:
            //clear work item to prevent changing to green
            markAsGreenWorkItem = nil
            
            handleColorAndDecimals()
            
            if isGreen == true {
                print("isgreen: true")
                scrambleLbl.isHidden = true
                if isRunning == false {
                    print("start")
                    startVisualTimer()
                    scrambleLbl.isHidden = true
                    scrambleLbl.text = scrambleMoves(21)
                } else {
                    
                }
            } else {
                dismissHalfBlack()
                stopTimer()
                print(totalSeconds)
                if totalSeconds != 0.0 {
                    saveTime()
                }
                isGreen = true
            }
        
            timeLbl.textColor = .white
        }
    
    }
    
    func saveTime() {
        
        timesModel.append(totalSeconds)
        
        var savedTimeRounded = String(Double(round(100*totalSeconds))/100)
        
        let savedTimeDouble = Double(savedTimeRounded)!
        
        if timesModel.isEmpty == false {
            if let min = timesModel.min(), savedTimeDouble < min {
                
            }
        }
        
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
    
        timesGlobal.insert(savedTimeRounded, at: 0)
        UserDefaults.standard.set(timesGlobal, forKey: Key.times)
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.timeZone   = TimeZone.current
        let date = dateFormatter.string(from: currentDate)
        
        let currentTime = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = TimeZone.current
        let time = timeFormatter.string(from: currentTime)
        
        timesTime.insert(time, at: 0)
        timesDate.insert(date, at: 0)
        timesScramble.insert(scrambleStr, at: 0)
    }
    
    func handleColorAndDecimals() {
        
        if let window = UIApplication.shared.keyWindow {
            blackView.frame = window.frame
            blackView.backgroundColor = UIColor(white: 1, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleStopwatch)))
            blackView.alpha = 0
            
            view.addSubview(blackView)
            view.bringSubview(toFront: timeLbl)
        
            
            if isRunning == true {
            view.backgroundColor = UIColor.randomized()
            blackView.alpha = 0
            } else {
            
                
                
            }
        }
    }
    
    func dismissHalfBlack() {
        blackView.alpha = 0
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
        scrambleLbl.isHidden = false
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
        
        //remove last decimal
        if stopwatchStr != "" {
            stopwatchStr.remove(at: stopwatchStr.index(before: stopwatchStr.endIndex))
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
    
    func setupAlert() {
        let alert = UIAlertController(title: "Congratulations! New PB!", message: "Would you like to view details for this solve?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            print("go to details")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
