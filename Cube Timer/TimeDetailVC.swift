//
//  TimeDetailVC.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-24.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class TimeDetailVC: UIViewController {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var scrambleLbl: UILabel!
    
    private var _rowInt: Int!
    
    var row: Int {
        get {
            return _rowInt
        } set {
            _rowInt = newValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print("Row: \(row)")
        
        print(GlobalTimes.times)
        print(GlobalTimes.date)
        print(GlobalTimes.time)
        print(GlobalTimes.scramble)
        
        self.title = GlobalTimes.times[row]
        
        scrambleLbl.text = GlobalTimes.scramble[row]
        dateLbl.text     = GlobalTimes.date[row]
        timeLbl.text     = GlobalTimes.time[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
