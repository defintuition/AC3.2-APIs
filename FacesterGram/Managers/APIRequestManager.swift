//
//  APIRequestManager.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal class APIRequestManager {
    private static let randomAPIEndpoint: URL = URL(string: "https://randomuser.me/api/?results=\(SettingsManager.manager.results)")!
    
    internal static let manager: APIRequestManager = APIRequestManager()
    private init() {}
    
    
    // MARK: - In class example
    func getRandomUserData(completion: @escaping ((Data?)->Void)) {
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: APIRequestManager.randomAPIEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(error?.localizedDescription)")
            }
            
            if data != nil {
                print("Data returned in response")
                completion(data)
            }
            
            }.resume()
    }
    
    
    // MARK: - solution to "Basic":
    // solution to first function exercise
    func getRandom(users: Int, completion: @escaping ((Data?)->Void) ) {
        let numberOfUsersEndpoint = URL(string: "https://randomuser.me/api/?results=\(users)")!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: numberOfUsersEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(error?.localizedDescription)")
            }
            
            if data != nil {
                print("Data returned in response")
                completion(data)
            }
            
            }.resume()
    }
    
    // solution to second function exercise
    func getRandom(users: Int, gender: UserGender, completion: @escaping ((Data?)->Void) ) {
        let countAndGenderEndpoint = URL(string: "https://randomuser.me/api/?results=\(users)&gender=\(gender.rawValue)")!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: countAndGenderEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(error?.localizedDescription)")
            }
            
            if data != nil {
                print("Data returned in response")
                completion(data)
            }
            
            }.resume()
    }
    
    // solution to third function exercise
    func getRandom(users: Int, nationality: UserNationality, completion: @escaping ((Data?)->Void) ) {
        let countAndGenderEndpoint = URL(string: "https://randomuser.me/api/?results=\(users)&nat=\(nationality.rawValue)")!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: countAndGenderEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(error?.localizedDescription)")
            }
            
            if data != nil {
                print("Data returned in response")
                completion(data)
            }
            
            }.resume()
    }
    
    // solution to "Advanced": https://github.com/C4Q/AC3.2-APIs#resources-for-advanced
    func getUsers(count: Int = 1, gender: UserGender = SettingsManager.manager.gender, nationality: [UserNationality] = SettingsManager.manager.validNationalities(), completion: @escaping ((Data?)->Void)) {
        // original solution
        // let endpoint: URL = URL(string: "https://randomuser.me/api/?results=\(count)&gender=\(gender.rawValue)&nat=\(nationality.rawValue)")!
        
        // using "Expert" solution to generate the appropriate URL
        let endpoint: URL = RandomUserURLFactory.manager.endpoint(users: count, nationality: nationality, gender: gender)
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: endpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered in API request: \(error?.localizedDescription)")
            }
            
            if data != nil {
                print("Data returned in response")
                completion(data)
            }
            
            }.resume()
    }

}
