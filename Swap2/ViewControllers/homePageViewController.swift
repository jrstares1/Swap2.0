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
    
    var uid = "";

    @IBOutlet weak var displayQR: UIImageView!
    
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
                uid = user.uid
                let email = user.email
    //           let photoURL = user.photoURL
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(uid)

                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(dataDescription)")
                        
                        let firstName = document.get("firstName") as! String
                        let lastName = document.get("lastName") as! String
                            
                        //setting the labels
                        self.nameLabel.text = firstName + " " + lastName
                        self.emailLabel.text = email
                            
                        }
                    }
                
                } else {
                  // No user is signed in.
                    print("sign them out")
                }
            }
        
        if (uid != "" ) {
            displayQR.image = generateCode(uid: uid)
        } else {
            let ac = UIAlertController(title: "Failed to Receive User ID", message: nil, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Dismiss", style: .default)
            
            ac.addAction(submitAction)
            self.present(ac, animated: true)
        }
    }
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    
    
    

}
