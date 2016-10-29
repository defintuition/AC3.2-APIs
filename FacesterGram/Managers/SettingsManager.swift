//
//  SettingsManager.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/24/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum UserGender: String {
    case male, female
    case both = ""
}

enum UserNationality: String {
    case AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US
    case all = ""
    
    func allNat() -> [String] {
        return [
            UserNationality.AU.rawValue, UserNationality.BR.rawValue, UserNationality.CA.rawValue,
            UserNationality.CH.rawValue, UserNationality.DE.rawValue, UserNationality.DK.rawValue,
            UserNationality.DK.rawValue, UserNationality.ES.rawValue, UserNationality.FI.rawValue,
            UserNationality.FR.rawValue, UserNationality.GB.rawValue, UserNationality.IE.rawValue,
            UserNationality.IR.rawValue, UserNationality.NL.rawValue, UserNationality.NZ.rawValue,
            UserNationality.TR.rawValue, UserNationality.US.rawValue
        ]
    }
}

enum UserField: String {
    case gender, name, location, email, login, id, picture, nat
    case none = ""
    
    func allFields() -> [String] {
        return [
            UserField.gender.rawValue, UserField.name.rawValue, UserField.location.rawValue,
            UserField.email.rawValue, UserField.login.rawValue, UserField.id.rawValue,
            UserField.picture.rawValue, UserField.nat.rawValue
        ]
    }
}

internal class SettingsManager: SliderCellDelegate, SegmentedCellDelegate, SwitchCellDelegate {
    
    var results: Int
    var gender: UserGender
    var nationality: [UserNationality]
    var excluded: [UserField]
    
    let minResults: Int = 1
    let maxResults: Int = 200
    
    static let manager: SettingsManager = SettingsManager()
    private init() {
        results = self.maxResults
        gender = .both
        nationality = [.all]
        excluded = [.none]
    }
    
    func updateNumberOfResults(_ results: Int) {
        if results < 1 {
            self.results = self.minResults
        }
        else if results > 200 {
            self.results = self.maxResults
        }
        else {
            self.results = results
        }
    }
    
    // MARK: - Slider Cell Delegate
    func sliderValueChanged(_ value: Int) {
        self.updateNumberOfResults(value)
    }
    
    // MARK: - Segmented Cell Delegate
    func segmentedValueChanged(_ gender: UserGender) {
        self.gender = gender
    }
    
    // MARK: - Switch Cell Delegate
    func selectionDidChange(option: String, value: Bool) {
        if let natSelection = UserNationality(rawValue: option) {
            // TODO: add/remove
        }
        
        if let fieldSelection = UserField(rawValue: option) {
            // TODO: add/remove
        }
    }
    
}
