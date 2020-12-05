//
//  ProfileViewController.swift
//  Swap2
//
//  Created by Justin Stares on 11/15/20.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var saveButton: UIButton!
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    var email: String = ""
    var newName: String = ""
    var newEmail: String = ""
    var newNumber: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        auth()
        setup()
        
    }

    @IBAction func save(_ sender: Any) {
        updateFields()
        self.view.removeFromSuperview()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func auth(){
        
    }
    @IBAction func editName(_ sender: Any) {
        self.newName = nameField.text ?? ""
    }
    
    @IBAction func editEmail(_ sender: Any) {
        self.newEmail = emailField.text ?? ""
    }
    
    @IBAction func editNumber(_ sender: Any) {
        self.newNumber = numberField.text ?? ""
    }
    
    func updateFields(){
        self.newName = nameField.text ?? ""
        self.newEmail = emailField.text ?? ""
        self.newNumber = numberField.text ?? ""
        if(newName != ""){
            print("name changed " + newName)
            GlobalVar.Name = newName
        }
        if(newEmail != ""){
            print("email changed")
            GlobalVar.Email = newEmail
        }
        if(newNumber != ""){
            print("number changed")
            GlobalVar.Number = newNumber
        }
        
        //TODO: import the phone number kit like we do on sign up
        //TODO: write values to db
        //TODO: sanitize inputs like we do in login
        
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                user.updateEmail(to: GlobalVar.Email, completion: {error in
                    if error != nil{
                        print(error ?? "no error")
                        print("error changing email")
                    }
                })
                user.sendEmailVerification(completion: {error in
                    if error != nil{
                        print("email welcome message was not send")
                    }
                })
                let db = Firestore.firestore()
                
                db.collection("users").document(uid).setData(["firstName":GlobalVar.Name, "phoneNumber":GlobalVar.Number], merge: true){ (error) in
                    if error != nil {
                        // Show error message
                        print(error ?? "no error")
                        print("error adding user data")
                    }
                    
                    
                }

            }

        }
        
    }
    func setup(){
        saveButton.backgroundColor = .clear
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        nameField.placeholder = GlobalVar.Name
        emailField.placeholder = GlobalVar.Email
        numberField.placeholder = GlobalVar.Number
    }
   

}
