//
//  deleteProfile.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 12/12/20.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftyJSON

func deleteProfile(){
    
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
                let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/user")
                guard let requestUrl = url else {fatalError()}
                
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "DELETE"
                
                // Append the token to request header
                request.setValue("Bearer " + idToken!, forHTTPHeaderField: "Authorization")
                
                // Send the request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    // Prints an error if an error occured
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    if let response = response as? HTTPURLResponse {
                        //print("Response HTTP Status Code: \(response.statusCode)")
                        if response.statusCode != 204 {
                            print("deletion did not work")
                            fatalError("deletion failed ")
                        }
                    }
                }
                
                task.resume()
                
            }
        }
    }
}

