//
//  StatisticsTVC.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-19.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class StatisticsTVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var stringArray = [String]()
    
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    let deciseconds = Array(0...99)
    let centiseconds = Array(0...99)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add new time", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (timeTextField) in
            timeTextField.placeholder = "Time"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
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
        allCell.textLabel?.text = timesGlobal[indexPath.row]
        allCell.textLabel?.textColor = UIColor.init(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        allCell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
        
        return allCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            timesGlobal.remove(at: indexPath.row)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(component)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutes.count
        } else if component == 1 {
            return seconds.count
        } else if component == 2 {
            return deciseconds.count
        }
        return centiseconds.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }
    
    func setupBackButton() {
        navigationController?.navigationBar.tintColor = UIColor.white
    }

}
