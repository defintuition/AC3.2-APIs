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
    
    func getRandomUserData(completion: @escaping ((Data?)->Void)) {
        let updatedRandomAPIEndpoint: URL = URL(string: "https://randomuser.me/api/?results=\(SettingsManager.manager.results)")!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: updatedRandomAPIEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
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
