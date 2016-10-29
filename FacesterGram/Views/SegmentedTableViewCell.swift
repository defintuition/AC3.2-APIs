//
//  SegmentedTableViewCell.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/28/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

protocol SegmentedCellDelegate: class {
    func segmentedValueChanged(_ gender: UserGender)
}

class SegmentedTableViewCell: UITableViewCell {
    internal weak var delegate: SegmentedCellDelegate?
    static let cellIdentifier: String = "SegmentedSelectionCellIdentifier"
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    internal func genderFor(segment: Int) -> UserGender {
        switch segment {
        case 0: return .both
        case 1: return .male
        default: return .female
        }
    }
    
    internal func segmentFor(gender: UserGender) -> Int {
        switch gender {
        case .both: return 0
        case .male: return 1
        default: return 2
        }
    }
    
    internal func updateSelectedSegment(index: Int) {
        genderSegmentedControl.selectedSegmentIndex = index
    }
    
    internal func updateSelectedSegment(gender: UserGender) {
        genderSegmentedControl.selectedSegmentIndex = segmentFor(gender: gender)
    }

    @IBAction func selectedSegmentDidChange(_ sender: UISegmentedControl) {
        self.delegate?.segmentedValueChanged(genderFor(segment: sender.selectedSegmentIndex))
    }
}
