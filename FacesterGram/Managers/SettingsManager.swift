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
    
    static func allNat() -> [String] {
        return [
            UserNationality.AU.rawValue, UserNationality.BR.rawValue, UserNationality.CA.rawValue,
            UserNationality.CH.rawValue, UserNationality.DE.rawValue, UserNationality.DK.rawValue,
            UserNationality.ES.rawValue, UserNationality.FI.rawValue, UserNationality.FR.rawValue,
            UserNationality.GB.rawValue, UserNationality.IE.rawValue, UserNationality.IR.rawValue,
            UserNationality.NL.rawValue, UserNationality.NZ.rawValue, UserNationality.TR.rawValue,
            UserNationality.US.rawValue
        ]
    }
    
    static func allNatEnums() -> [UserNationality] {
        return UserNationality.allNat().map({ (nat: String) -> UserNationality in
            return UserNationality(rawValue: nat)!
        })
    }
}

enum UserField: String {
    case gender, name, location, email, login, id, picture, nat
    case none = ""
    
    static func allFields() -> [String] {
        return [
            UserField.gender.rawValue, UserField.name.rawValue, UserField.location.rawValue,
            UserField.email.rawValue, UserField.login.rawValue, UserField.id.rawValue,
            UserField.picture.rawValue, UserField.nat.rawValue
        ]
    }
    
    static func allFieldEnums() -> [UserField] {
        return UserField.allFields().map({ (field: String) -> UserField in
            return UserField(rawValue: field)!
        })
    }
}

internal class SettingsManager: SliderCellDelegate, SegmentedCellDelegate, SwitchCellDelegate {
    
    var results: Int
    var gender: UserGender
    var nationality: [UserNationality]
    var included: [UserField]
    
    // SwitchCellDelegate var
    var userNationalitySwitchStatus: [String : Bool]
    var userFieldsSwitchStatus: [String : Bool]
    
    // We need to ensure a specified order
    var sortedNationalityKeys: [String]
    var sortedFieldKeys: [String]
    
    let minResults: Int = 1
    let maxResults: Int = 200
    
    static let manager: SettingsManager = SettingsManager()
    private init() {
        results = self.minResults
        gender = .both
        nationality = UserNationality.allNatEnums()
        included = UserField.allFieldEnums()
        
        // define a closure intended to create a dictionary by iterrating over an array of String,
        // and using the String as the key for a Bool value corresponding to if the switch cell option
        // should be currently true or false
        let dictionaryReduce = { (dict: [String: Bool], option: String ) -> [String : Bool] in
            var reduceDict = dict
            reduceDict[option] = true
            return reduceDict
        }
        
        // kinda weird, but the reduce function signature is 
        // func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
        // 
        // In this particular case, Result is of type [String : Bool] and Element is of type String
        userNationalitySwitchStatus = UserNationality.allNat().reduce([String : Bool](), dictionaryReduce)
        userFieldsSwitchStatus = UserField.allFields().reduce([String : Bool](), dictionaryReduce)
        
        sortedNationalityKeys = userNationalitySwitchStatus.keys.sorted(by: <)
        sortedFieldKeys = userFieldsSwitchStatus.keys.sorted(by: <)
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
    
    // MARK: - Helpers
    internal func validNationalities() -> [UserNationality] {
        let allValidNats: [String] = validValues(self.userNationalitySwitchStatus)
        
        return allValidNats.flatMap({ (nat: String) -> UserNationality? in
            return UserNationality(rawValue: nat)
        })
    }
    
    internal func validFields() -> [UserNationality] {
        let allValidFields: [String] = validValues(self.userFieldsSwitchStatus)
        
        return allValidFields.flatMap({ (nat: String) -> UserNationality? in
            return UserNationality(rawValue: nat)
        })
    }
    
    private func validValues(_ dict: [String : Bool]) -> [String] {
        return dict.flatMap({ (key: String, value: Bool) -> String? in
            if value {
                return key
            }
            return nil
        })
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
        
        // we maintain two internal dictionaries corresponding to our nationalities and fields
        // We do a nil-check to see if we can create the enum using the String option passed
        if let _ = UserNationality(rawValue: option) {
            self.userNationalitySwitchStatus[option] = value
        }
        
        if let _ = UserField(rawValue: option) {
            self.userFieldsSwitchStatus[option] = value
        }
    }
    
}
