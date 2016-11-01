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
    
    static func allNatEnums() -> [UserNationality] {
        return [AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US]
    }
}

enum UserField: String {
    case gender, name, location, email, login, id, picture, nat
    case none = ""
    
    static func allFieldEnums() -> [UserField] {
        return [gender, name, location, email, login, id, picture, nat]
    }
}

internal class SettingsManager: SliderCellDelegate, SegmentedCellDelegate, SwitchCellDelegate {
    
    var results: Int
    var gender: UserGender
    var nationality: [UserNationality]
    var included: [UserField]
    
    // SwitchCellDicts
    var userNationalitySwitchStatus: [UserNationality : Bool] = [
        UserNationality.AU : true, UserNationality.BR: true,
        UserNationality.CA : true, UserNationality.CH : true,
        UserNationality.DE : true, UserNationality.DK : true,
        UserNationality.ES : true, UserNationality.FI : true,
        UserNationality.FR : true, UserNationality.GB : true,
        UserNationality.IE : true, UserNationality.IR : true,
        UserNationality.NL : true, UserNationality.NZ : true,
        UserNationality.TR : true, UserNationality.US : true
    ]
    var userFieldsSwitchStatus: [UserField : Bool] = [
        UserField.gender : true, UserField.name : true,
        UserField.location : true, UserField.email : true,
        UserField.login : true, UserField.id : true,
        UserField.picture : true, UserField.nat : true
    ]
    
    // We need to ensure a specified order
    var sortedNationalityKeys: [String] {
        return userNationalitySwitchStatus.keys.map{ $0.rawValue }.sorted(by: >)
    }
    var sortedFieldKeys: [String] {
        return userFieldsSwitchStatus.keys.map { $0.rawValue }.sorted(by: >)
    }
    
    let minResults: Int = 1
    let maxResults: Int = 200
    
    static let manager: SettingsManager = SettingsManager()
    private init() {
        results = self.minResults
        gender = .both
        nationality = UserNationality.allNatEnums()
        included = UserField.allFieldEnums()
    }
    
    func updateNumberOfResults(_ results: Int) {
        if results < minResults {
            self.results = minResults
        }
        else if results > maxResults {
            self.results = maxResults
        }
        else {
            self.results = results
        }
    }
    
    // MARK: - UserDefaults
    func saveSettings() {
        let defaults = UserDefaults.standard
        
        var formattedNats: [String : Bool] = [:]
        for nat in self.sortedNationalityKeys {
            formattedNats[nat] = userNationalitySwitchStatus[UserNationality(rawValue: nat)!]!
        }
        
        defaults.set(formattedNats, forKey: "UserNationalityFilterKey")
        defaults.set(gender.rawValue, forKey: "UserGenderFilterKey")
        defaults.set(results, forKey: "UserResultsFilterKey")
    }
    
    func loadSettings() {
        
        let defaults = UserDefaults.standard
        
        if let userNatFilter: [String : Bool] = defaults.value(forKey: "UserNationalityFilterKey") as? [String : Bool] {
            print("Loaded Nat Filter Settings")
            
            var reformedNatStatus: [UserNationality : Bool] = [:]
            for (natRawValue, status) in userNatFilter {
                reformedNatStatus[UserNationality(rawValue: natRawValue)!] = status
            }
            
            self.userNationalitySwitchStatus = reformedNatStatus
        }
        
        if let userGenderFilterRaw: String = defaults.value(forKey: "UserGenderFilterKey") as? String,
            let userGenderFilter: UserGender = UserGender(rawValue: userGenderFilterRaw) {
            print("Loaded Gender Filter Settings")
            self.gender = userGenderFilter
        }
        
        if let userResultsFilter: Int = defaults.value(forKey: "UserResultsFilterKey") as? Int {
            print("Loaded Results Filter Settings")
            self.results = userResultsFilter
        }
    
    }
    
    // MARK: - Helpers
    func validNationalities() -> [UserNationality] {
        return validValues(self.userNationalitySwitchStatus)
    }
    
    func validValues<T: Hashable>(_ dict: [T : Bool]) -> [T] {
        var returnValues: [T] = []
        for (key, value) in dict {
            if value == true {
                returnValues.append(key)
            }
        }
        return returnValues
    }
    
    
    // MARK: - Slider Cell Delegate
    func sliderValueChanged(_ value: Int) {
        self.updateNumberOfResults(value)
        self.saveSettings()
    }
    
    // MARK: - Segmented Cell Delegate
    func segmentedValueChanged(_ gender: UserGender) {
        self.gender = gender
        self.saveSettings()
    }
    
    // MARK: - Switch Cell Delegate
    func selectionDidChange(option: String, value: Bool) {
        
        // we maintain two internal dictionaries corresponding to our nationalities and fields
        // We do a nil-check to see if we can create the enum using the String option passed
        if let userNationality = UserNationality(rawValue: option) {
            self.userNationalitySwitchStatus[userNationality] = value
        }
        
        if let userField = UserField(rawValue: option) {
            self.userFieldsSwitchStatus[userField] = value
        }
        
        self.saveSettings()
    }
    
}
