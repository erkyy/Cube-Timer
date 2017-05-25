//
//  StatisticsTVC.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-19.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class StatisticsTVC: UITableViewController, UITextFieldDelegate {
    
    var stringArray = [String]()
    var row = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let editBtn = editButtonItem
        editBtn.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = editBtn
        
    }
    
    func averageOf(_ of: Int) -> String {
        
        var result = "--"
        
        if timesGlobal.count >= of {
            
            let lastOfSlice: ArraySlice<Double> = timesModel.suffix(of)
            let resultDouble = Array(lastOfSlice).reduce(0, +) / Double(of)
            let resultDoubleRounded = Double(round(100*resultDouble)/100)
            
            result = String(resultDoubleRounded)
            
            if resultDouble > 60.0 {
                let seconds = resultDouble.truncatingRemainder(dividingBy: 60)
                let secondsRounded = Double(round(100*seconds)/100)
                let minutes: Int? = Int((resultDouble / 60).truncatingRemainder(dividingBy: 60))
                
                result = "\(minutes!):\(secondsRounded)"
                
                if minutes != nil {
                    if seconds < 10.0 {
                        result = "\(minutes!):0\(secondsRounded)"
                    }
                }
            }
        }
        return result
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let averageCell = UITableViewCell(style: .default, reuseIdentifier: TableViewCellIdentifier.averageCell)
            
            let averageTextHeader = ["Average of 5", "Average of 12"]
            var averageTimesLabels = [averageOf(5), averageOf(12)]
            
            averageCell.textLabel?.text = averageTextHeader[indexPath.row]
            averageCell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17)
            averageCell.textLabel?.textColor = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
            averageCell.isUserInteractionEnabled = false
            
            let averageTimeLabel = UILabel(frame: CGRect(x: averageCell.frame.width - 120, y: 0, width: 160, height: averageCell.frame.height))
            
            averageTimeLabel.text = averageTimesLabels[indexPath.row]
            averageTimeLabel.textAlignment = .right
            averageTimeLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
            averageTimeLabel.textColor = UIColor.init(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            
            averageCell.addSubview(averageTimeLabel)
                
            return averageCell
        }
    
        let allCell = UITableViewCell(style: .default, reuseIdentifier: TableViewCellIdentifier.allCell)
        allCell.accessoryType = .disclosureIndicator
        allCell.textLabel?.text = timesGlobal[indexPath.row]
        allCell.textLabel?.textColor = UIColor.init(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        allCell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
        
        return allCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        row = indexPath.row
        
        performSegue(withIdentifier: SegueIdentifier.toTimeDetailVC, sender: row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard var timesKey = UserDefaults.standard.stringArray(forKey: Key.times) else { return }
            
            timesGlobal.remove(at: indexPath.row)
            timesKey.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return timesGlobal.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Average"
        }
        return "All"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toTimeDetailVC {
            if let dest = segue.destination as? TimeDetailVC {
                dest.row = sender as! Int
            }
        }
        
        
        setupBackButton()
    }
    
    func setupBackButton() {
        navigationController?.navigationBar.tintColor = UIColor.white
    }

}
