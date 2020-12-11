//
//  Twitter.swift
//  Swap2
//
//  Created by Justin Stares on 11/24/20.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftyJSON


func addTwitter() -> Bool{
    if (Auth.auth().currentUser != nil) {
        var success = false
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
                if (response.statusCode == 201){
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
                
            
            let url2 = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/twitter/authorizeUrl")
            guard let requestUrl2 = url2 else { fatalError() }
            // Create URL Request
            var request2 = URLRequest(url: requestUrl2)
            // Specify HTTP Method to use
            request2.httpMethod = "GET"
            // Request Header
            request2.setValue("Bearer " + idToken!, forHTTPHeaderField: "Authorization")
                
            func getDetail(withRequest request: URLRequest, withCompletion completion: @escaping (String?, Error?) -> Void) {

                // Send HTTP Request
                let task2 = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // Check if Error took place
                    if let error2 = error {
                        print("Twitter Url Error took place \(error2)")
                        completion(nil, error)
                        return
                    }
                    // Read HTTP Response Status code
                    if let response2 = response as? HTTPURLResponse {
                        print("Twitter Url Response HTTP Status code: \(response2.statusCode)")
                        if (response2.statusCode == 201){
                            success = true
                        }
                    }
                    //ADD Later if we get a 403 error stop.
                    
                    // Convert HTTP Response Data to a simple String
                    if let data2 = data, let dataString2 = String(data: data2, encoding: .utf8) {
                        do {
                            print("Twitter Url Response data string:\n \(dataString2)")

                            guard let json = try JSONSerialization.jsonObject(with: data2, options: []) as? [String:Any] else {completion(nil, nil);return}
                            guard let details = json["redirectUrl"] as? String else {completion(nil, nil);return}
                            GlobalVar.oauthRequestToken = (json["oauthRequestToken"] as? String)!
                            GlobalVar.oauthRequestTokenSecret = (json["oauthRequestTokenSecret"] as? String)!

                            completion(details, nil)
                       }
                       catch {
                            completion(nil, error)
                       }
                        
                                        
                    }
                }
                task2.resume()
                
            }
                
                
            getDetail(withRequest: request2, withCompletion: { detail, error in
                if error != nil {
                    //handle error
                } else if detail == detail {
                    //You can use detail here
                    if let url3 = URL(string: detail!) {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(url3)
                        }
                        
                    }
//                    GlobalVar.redirectUrl = detail!
                }
            })
            
                
                
//            if let url3 = URL(string: GlobalVar.redirectUrl) {
//                UIApplication.shared.open(url3)
//            }
            
                
            
//            print("check here")
//            print(GlobalVar.redirectUrl)
//            //Now send to the url
//            if let url3 = URL(string: GlobalVar.redirectUrl) {
//                UIApplication.shared.open(url3)
//            }
        
            }
                

        }
        return success;
    }
    else {
        //TODO: do we need to implement this??? justin
        print("sign them out")
        return false;
    }
    

}

func deleteTwitter(){
    
    //NOT YET IMPLEMENTEND
        
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
                let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/twitter")
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



