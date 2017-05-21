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
    
    var timer          = Timer()
    var isRunning      = false
    
    var minutes: Int   = 0
    var seconds: Int   = 0
    var fractions: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(timesGlobal.joined(separator: ", "))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        timeLbl.text = "0.00"
        
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
            startTimer()
            scrambleLbl.isHidden = true
            
        } else {
            stopTimer()
            saveTime()
            scrambleLbl.isHidden = false
            
        }
    }
    
    func startTimer() {
        minutes      = 0
        seconds      = 0
        fractions    = 0
        timeLbl.text = "0.00"
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stopTimer() {
        timer.invalidate() //stop
        isRunning = false
    }
    
    func updateTimer() {
        
        fractions += 1
        
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
        
        timeLbl.text = stopwatchStr
    }
    
    func saveTime() {
        guard let time = timeLbl.text else { return }
        timesGlobal.append(time)
        
        UserDefaults.standard.set(timesGlobal, forKey: Key.timesKey)
        
        print("Saved times. \(timesGlobal.joined(separator: ", "))")
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
