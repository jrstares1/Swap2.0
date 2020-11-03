//
//  AddContact.swift
//  Swap2
//
//  Created by Mitch Frauenheim on 11/2/20.
//

import Foundation
import Contacts
import UIKit

func addContact(info: [String:String]) {
    
    print("attempting to add contact")
    
    let contact = CNMutableContact()
    
    for (key, _) in info {
        if (key == "firstName") {
            contact.givenName = info[key] ?? ""
        }
        
        if (key == "lastName") {
            contact.familyName = info[key] ?? ""
        }
        
        if (key == "email") {
            contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: (info[key] ?? "") as NSString)]
        }
        
        if (key == "phoneNumber") {
            contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: info[key] ?? ""))]
        }
    }
    
    let store = CNContactStore()
    let saveRequest = CNSaveRequest()
    saveRequest.add(contact, toContainerWithIdentifier: nil)
    
    do {
        try store.execute(saveRequest)
    } catch {
        print("Saving contact failed, error: \(error)")
    }
}
