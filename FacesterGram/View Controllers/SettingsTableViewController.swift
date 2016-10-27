//
//  SettingsTableViewController.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    private static let SettingsTableViewCellIdentifier: String = "SettingsTableViewCellIdentifier"
    private static let SwitchCellIdentifier: String = "SwitchCell"
    private static let SegmentedControlCellIdentifier: String = "SegmentedControlCell"
    private static let SliderCellIdentifier: String = "SliderCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Tableview Delegate/Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewController.SliderCellIdentifier, for: indexPath)
            
            if let sliderCell: SliderTableViewCell = cell as? SliderTableViewCell {
                sliderCell.updateSlider(min: SettingsManager.manager.minResults,
                                        max: SettingsManager.manager.maxResults,
                                        current: SettingsManager.manager.results)
                
                // ok lets see what happens when you set the delegation 
                sliderCell.delegate = SettingsManager.manager
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewController.SegmentedControlCellIdentifier, for: indexPath)
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewController.SwitchCellIdentifier, for: indexPath)
        }
        
        return cell
    }

}
