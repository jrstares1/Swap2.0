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
    
    print("deleting " + account + " account")
    if(account == "Github"){
        print("deleting " + account + " account")
        deleteGithub()
    }
    else{
        print("have not implemented API to delete this type of account")
    }
}
