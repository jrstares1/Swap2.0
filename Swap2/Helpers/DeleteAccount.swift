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
    else if(account == "Spotify"){
        deleteSpotify()
    }
    else if (account == "Twitter"){
        deleteTwitter()
    }
    else{
        print("have not implemented API to delete this type of account")
    }
}




