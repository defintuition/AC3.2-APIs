//
//  SettingsTableViewController.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

enum SettingsSectionIdentifier {
    case resultsSlider, genderSegment, nationalitySwitches
}

class SettingsTableViewController: UITableViewController {

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
        if section == 2 {
            return SettingsManager.manager.userNationalitySwitchStatus.keys.count
        }
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.cellIdentifier, for: indexPath)
            
            if let sliderCell: SliderTableViewCell = cell as? SliderTableViewCell {
                sliderCell.updateSlider(min: SettingsManager.manager.minResults,
                                        max: SettingsManager.manager.maxResults,
                                        current: SettingsManager.manager.results)
                
                // ok lets see what happens when you set the delegation 
                sliderCell.delegate = SettingsManager.manager
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: SegmentedTableViewCell.cellIdentifier, for: indexPath)
            
            if let segmentedCell: SegmentedTableViewCell = cell as? SegmentedTableViewCell {
                segmentedCell.updateSelectedSegment(gender: SettingsManager.manager.gender)
                segmentedCell.delegate = SettingsManager.manager
            }
            
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.cellIdentifier, for: indexPath)
            
            if let switchCell: SwitchTableViewCell = cell as? SwitchTableViewCell {
                
                let key: String = SettingsManager.manager.sortedNationalityKeys[indexPath.row]
                switchCell.updateElements(key: key, value: SettingsManager.manager.userNationalitySwitchStatus[UserNationality(rawValue: key)!]!)
                switchCell.delegate = SettingsManager.manager
            }
        }
        
        return cell
    }
    
    // We're going to give our sections a little bit of distinction
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return nil
    }

}
