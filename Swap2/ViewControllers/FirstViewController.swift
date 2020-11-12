//
//  FirstViewController.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit
import FirebaseAuth
import Firebase

class FirstViewController: UIViewController {
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if userDefault.bool(forKey: "usersignedin") {
            
            
            if (Auth.auth().currentUser != nil) {
                // User is signed in.
                print("user has signed in before")
                let user = Auth.auth().currentUser
                if let user = user {
                    let uid = user.uid
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document(uid)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            print("Document data: \(dataDescription)")
                            let firstName = document.get("firstName") as! String
                            let lastName = document.get("lastName") as! String
                            let phoneNumber = document.get("phoneNumber") as! String
                            GlobalVar.Name = (firstName + " " + lastName)
                            GlobalVar.Number = phoneNumber
                        } else {
                            print("Document does not exist")
                        }
                    }
                }

            }
            
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
            self.present(initViewController, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        //Styling elements
        Utilities.styleFilledButton(signUpButton)
        
        Utilities.styleHollowButton(loginButton)

    }
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func loginTapped(_ sender: Any) {
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
