//
//  StatisticsTVC.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-19.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class StatisticsTVC: UITableViewController {

    var averageTimesLabels = ["1:37.12", "4:14.97"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        roundTimes()
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func roundTimes() {
        
        for var time in timesGlobal {
            time = Double(round(100*time)/100)
            print(time)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let averageCell = UITableViewCell(style: .default, reuseIdentifier: TableViewCellIdentifier.averageCell)
            
            let averageTextHeader = ["Average of 5", "Average of 12"]
            
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
        allCell.textLabel?.text = String(timesGlobal[indexPath.row])
        allCell.textLabel?.textColor = UIColor.init(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        allCell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
        
        return allCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
    
    func stringFromInterval(_ time: TimeInterval) -> String {
        
        var result = String(time)
        
        if time > 60.0 {
            let seconds = time.truncatingRemainder(dividingBy: 60)
            let secondsRounded = Double(round(100*seconds)/100)
            let minutes = Int((time / 60).truncatingRemainder(dividingBy: 60))
            result = "\(minutes):\(secondsRounded)"
        }
        
        print(result)
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
    }
    
    func setupBackButton() {
        navigationController?.navigationBar.tintColor = UIColor.white
    }

}
