//
//  SettingsTVC.swift
//  Cube Timer
//
//  Created by Erik Myhrberg on 2017-05-21.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        testAlert()
    }
    
    func testAlert() {
        let alert = UIAlertController(title: "Remove ALL times?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            GlobalTimes.scramble.removeAll()
            GlobalTimes.date.removeAll()
            GlobalTimes.model.removeAll()
            GlobalTimes.times.removeAll()
            GlobalTimes.time.removeAll()
            UserDefaults.standard.removeObject(forKey: Key.times)
            print("removed all times")
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Timer"
        }
        return "General"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let timerCell = UITableViewCell(style: .subtitle, reuseIdentifier: TableViewCellIdentifier.timerCell)
            
            let secondsSlider = UISlider(frame: CGRect(x: 50, y: 100, width: 80, height: 20))
            secondsSlider.minimumValue = 0
            secondsSlider.maximumValue = 15
            secondsSlider.value = 0
            
            view.addSubview(secondsSlider)
        
            
            let textLabels   = ["Inspection time", "2", "3", "4", "5"]
            let detailLabels = [("0 seconds"), "2", "3", "4", "5"]
            timerCell.tag = indexPath.row
            timerCell.textLabel?.text = textLabels[indexPath.row]
            timerCell.detailTextLabel?.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
            timerCell.detailTextLabel?.text = detailLabels[indexPath.row]
            
            return timerCell
        }
        let generalCell = UITableViewCell(style: .default, reuseIdentifier: TableViewCellIdentifier.generalCell)
        
        generalCell.textLabel?.text = "General"
        
        return generalCell
        
    }
    
    func sliderValueChanged(sender: UISlider) {
        let sliderValue = String(Int(sender.value))
        
        print(sliderValue)
    }
    
}
