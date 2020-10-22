//
//  homePageViewController.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit
import FirebaseAuth
import Firebase

class homePageViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (Auth.auth().currentUser != nil) {
          // User is signed in.
          
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
    //           let photoURL = user.photoURL
                print("uid1 " + uid)
                let db = Firestore.firestore()
                let docRef = db.collection("users").whereField("uid", isEqualTo: uid)
                
                docRef.getDocuments { (snapshot, error) in
                        guard let snapshot = snapshot else {
                            print("Error \(error!)")
                            return
                        }
                        for document in snapshot.documents {
                            let documentId = document.documentID
                            print("doc id " + documentId) //This print all objects
                            
                            let firstname = document.get("firstname") as! String
                            print("first name " + firstname)
                            
                            let lastname = document.get("lastname") as! String
                            print("last name " + lastname)
                            
                            //setting the labels
                            self.nameLabel.text = firstname + " " + lastname
                            self.emailLabel.text = email

                            
                            }
                        }
                
                } else {
                  // No user is signed in.
                    print("sign them out")
                }
            }
        
        
        
        
    }
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    
    
    

}
