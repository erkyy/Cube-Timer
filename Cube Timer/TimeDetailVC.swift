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
        
        self.title = timesGlobal[row]
        
        scrambleLbl.text = timesScramble[row]
        dateLbl.text     = timesDate[row]
        timeLbl.text     = timesTime[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
