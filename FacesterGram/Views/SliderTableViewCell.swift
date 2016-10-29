//
//  SliderTableViewCell.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

protocol SliderCellDelegate: class {
    func sliderValueChanged(_ value: Int)
}

class SliderTableViewCell: UITableViewCell {
    internal weak var delegate: SliderCellDelegate?
    
    static let cellIdentifier: String = "SliderCellIdentifier"
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var numberOfResultsLabel: UILabel!
    
    internal func updateSlider(min: Int, max: Int, current: Int) {
        self.slider.minimumValue = Float(min)
        self.slider.maximumValue = Float(max)
        self.slider.setValue(Float(current), animated: true)
        
        self.numberOfResultsLabel.text = "\(current)"
    }

    @IBAction func didChangeValue(_ sender: UISlider) {
        self.numberOfResultsLabel.text = "\(Int(sender.value))"
        self.delegate?.sliderValueChanged(Int(sender.value))
    }
}
