//
//  Reddit.swift
//  Swap2
//
//  Created by Justin Stares on 12/5/20.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftyJSON

func addReddit() -> Bool {
    if (Auth.auth().currentUser != nil) {
        var success = false;
        let user = Auth.auth().currentUser
        if let user = user {
            user.getIDTokenForcingRefresh(true) { idToken, error in
                if error != nil {
                    return;
            }
            GlobalVar.IdToken = idToken!
            // Send token to your backend via HTTPS
            let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/user")
            guard let requestUrl = url else { fatalError() }

            // Create URL Request
            var request = URLRequest(url: requestUrl)

            // Specify HTTP Method to use
            request.httpMethod = "GET"
              
            // Request Header
            request.setValue("Bearer " + idToken!, forHTTPHeaderField: "Authorization")
            // Send HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                    return
            }
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
                if(response.statusCode == 201){
                    success = true
                }
            }
                
            //ADD Later if we get a 403 error stop.
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            }
            task.resume()
            //Now send to the url
            if let url = URL(string: "https://www.reddit.com/api/v1/authorize?client_id=wY06c42CJI-o1Q&response_type=code&state=swap&redirect_uri=swap2%3A%2F%2Freddit%2F&duration=permanent&scope=identity+subscribe") {
                UIApplication.shared.open(url)
                }
            }
        }
        return success;
    }
    else {
        //TODO do we need to implement this???
        print("sign them out")
        return false;
    }
    

}

func deleteReddit(){
    //Not yet implemented
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
                let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/reddit")
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
