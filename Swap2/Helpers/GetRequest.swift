//
//  GetRequest.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 10/27/20.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftyJSON


func swapWith(string: String) {
    
    var userInfo = [String:String]()
    
    if (Auth.auth().currentUser != nil) {
        // User is signed in.
        let user = Auth.auth().currentUser

        if let user = user {
            
            user.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    // Handle error
                    print("Something is wrong with the token\n Error: \(error)")
                    return;
                }

                // Create the url and subsequently the request
                let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/swap/" + string)
                //print("User ID for get request is: " + string)
                guard let requestUrl = url else {fatalError()}
                
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
                
                // Append the token to request header
                request.setValue("Bearer " + idToken!, forHTTPHeaderField: "Authorization")
                
                // Send the request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Prints an error if an error occured
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    
                    // Print the response status code
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status Code: \(response.statusCode)")
                    }
                    
                    // Print out the response data as a string
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("Response data string:\n \(dataString)")
                        
                        do {
                            let json = try JSON(data: data)
                            userInfo["firstName"] = json["userData"]["firstName"].string ?? "no first"
                            userInfo["lastName"] = json["userData"]["lastName"].string ?? "no last name"
                            userInfo["email"] = json["userData"]["email"].string ?? "no email"
                            userInfo["phoneNumber"] = (json["userData"]["phoneNumber "].string ?? "no phone number").replacingOccurrences(of: "-", with: "")
                            
                           addContact(info: userInfo)
                            
                        } catch{
                            print(error)
                        }
                    }
                
                    
                    print("Errors and responses printed")
                }
                
                task.resume()
            }
        }
    }
}

