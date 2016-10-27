//
//  SettingsManager.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum UserGender: String {
    case male, female, both
}

enum UserNationality: String {
    case AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US, all
}

enum UserField: String {
    case gender, name, location, email, login, id, picture, nat, none
}

internal class SettingsManager: SliderCellDelegate {
    
    var results: Int
    var gender: UserGender
    var nationality: UserNationality
    var excluded: UserField
    
    let minResults: Int = 1
    let maxResults: Int = 200
    
    static let manager: SettingsManager = SettingsManager()
    private init() {
        results = 1
        gender = .both
        nationality = .all
        excluded = .none
    }
    
    func updateNumberOfResults(_ results: Int) {
        if results < 1 { self.results = 1 }
        else if results > 200 { self.results = 200 }
        else {
            self.results = results
        }
    }
    
    // MARK: - Slider Cell Delegate
    func sliderValueChanged(_ value: Int) {
        self.updateNumberOfResults(value)
    }
}
