//
//  GetRequest.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 10/27/20.
//

import Foundation

func swapWith(string: String) {
    
    // Create the url and subsequently the request
    let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/user" + string)
    guard let requestUrl = url else {fatalError()}
    
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
    
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
        }
    }
    
    task.resume()
}
