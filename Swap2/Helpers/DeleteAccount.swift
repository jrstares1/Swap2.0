//
//  DeleteAccount.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 11/13/20.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftyJSON

func deleteAccount(_ account: String){
    
  
    if(account == "Github"){
        deleteGithub()
    }
    if(account == "Spotify"){
        
    }
    else{
        print("have not implemented API to delete this type of account")
    }
}
