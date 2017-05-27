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
            timesScramble.removeAll()
            timesDate.removeAll()
            timesModel.removeAll()
            timesGlobal.removeAll()
            UserDefaults.standard.removeObject(forKey: Key.times)
            print("removed all times")
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let test = UITableViewCell(style: .default, reuseIdentifier: TableViewCellIdentifier.testCell)
        
        
        return test
    }
    
}
