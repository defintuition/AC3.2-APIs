//
//  User.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal enum UserModelParseError: Error {
    case results(json: Any)
    case name(json: AnyObject)
    case location(json: AnyObject)
    case login(json: AnyObject)
    case id(json: AnyObject)
    case pictures(json: AnyObject)
    case email(json: AnyObject)
}

internal struct User {
    internal let firstName: String
    internal let lastName: String
    internal let city: String
    internal let state: String
    internal let username: String
    internal let emailAddress: String
    internal let id: String
    internal let thumbnailURL: String
    
    static func users(from data: Data) -> [User]? {
        var usersToReturn: [User]? = []
        
        do {
            // 1. Attempt to serialize data
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            // 2. begin parsing to our array of user data objects
            guard let response: [String : AnyObject] = jsonData as? [String : AnyObject],
                let results: [AnyObject] = response["results"] as? [AnyObject] else {
                throw UserModelParseError.results(json: jsonData)
            }
            
            // 3. Iterrate over each element
            for userResult in results {
                
                // 4. parse out name
                guard
                    let name: [String : String] = userResult["name"] as? [String : String],
                    let first: String = name["first"],
                    let last: String = name["last"]
                else {
                    throw UserModelParseError.name(json: userResult)
                }
                
                // 5. parse out location
                // ** There will be some problems here: doing [String : String] will occasionally fail since some of the fields are interpreted as Int
                // ** Switch to [String : AnyObject] followed by further type casting **
                guard
                    let location: [String : AnyObject] = userResult["location"] as? [String : AnyObject],
                    let city: String = location["city"] as? String,
                    let state: String = location["state"] as? String
                else {
                    throw UserModelParseError.login(json: userResult)
                }
                
                // 6. parse out user name
                guard
                    let login: [String : String] = userResult["login"] as? [String : String],
                    let username: String = login["username"]
                else {
                    throw UserModelParseError.login(json: userResult)
                }
                
                // 7. parse out id
                // ** There will be another problem here: depending on nationality, idValue will be nill **
                // ** Good place to handle errors gracefully **
                // ** Options here include making the id optional, or generating a random one, or accepting that this will always return nil
                guard
                    let id: [String : AnyObject] = userResult["id"] as? [String : AnyObject]//,
                else {
                    throw UserModelParseError.id(json: userResult)
                }
                
                // 8. parse out image URLs
                guard
                    let pictures: [String : String] = userResult["picture"] as? [String : String],
                    let thumbnail: String = pictures["thumbnail"]
                else {
                    throw UserModelParseError.pictures(json: userResult)
                }
                
                // 9. the rest
                guard let email: String = userResult["email"] as? String else {
                    throw UserModelParseError.email(json: userResult)
                }
                
                let validUser: User = User(firstName: first,
                                           lastName: last,
                                           city: city,
                                           state: state,
                                           username: username,
                                           emailAddress: email,
                                           id: (id["value"] as? String) ?? "N/A",
                                           thumbnailURL: thumbnail)
                
                usersToReturn?.append(validUser)
            }
            
            return usersToReturn
        }
        catch let UserModelParseError.results(json: json) {
            print("Error encountered with parsing 'results' key for object: \(json)")
        }
        catch let UserModelParseError.name(json: json) {
            print("Error encountered with parsing 'name' key for object: \(json)")
        }
        catch let UserModelParseError.location(json: json) {
            print("Error encountered with parsing 'location' key for object: \(json)")
        }
        catch let UserModelParseError.login(json: json) {
            print("Error encountered with parsing 'login' key for object: \(json)")
        }
        catch let UserModelParseError.id(json: json) {
            print("Error encountered with parsing 'id' key for object: \(json)")
        }
        catch let UserModelParseError.pictures(json: json) {
            print("Error encountered with parsing 'pictures' key for object: \(json)")
        }
        catch let UserModelParseError.email(json: json) {
            print("Error encountered with parsing 'email' key for object: \(json)")
        }
        catch {
            print("Error encountered with parsing: \(error)")
        }
        
        print("returning nil")
        return nil
    }
    
}
