//
//  RandomUserURLFactory.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/28/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal class RandomUserURLFactory {
    
    internal static let baseEndpoint: String = "https://randomuser.me/api/?"
    internal static let manager: RandomUserURLFactory = RandomUserURLFactory()
    private init(){}
    
    // https://randomuser.me/api/?results=2&nat=AU,BR,GB&gender=
    func endpoint(users: Int, nationality: [UserNationality], gender: UserGender) -> URL {
        
        // note: this is just one way of accomplishing this task. compare your answer with this one and think
        // about how you'd like to write your code in the future
        let results = "results=\(users)"
        let gender = "gender=\(gender.rawValue)"
        
        // note: flatmap, in this usage, iterates over the elements in the array, and returns an array
        // of String. Then, all of the values get joined with a comma, before being added to the "nat=" string
        let nat = "nat=" + nationality.flatMap { (nat) -> String? in
            return nat.rawValue
            }.joined(separator: ",")
        
        let appendedURL = [results, nat, gender].joined(separator: "&")
        
        return URL(string: RandomUserURLFactory.baseEndpoint + appendedURL)!
    }
}
