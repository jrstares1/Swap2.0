//
//  LogInViewController.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0; //make it transparent to begin
        
        //Styling elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)

    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func enterClicked(_ sender: Any) {
        loginTapped((Any).self)
    }
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Couldn't sign in
                print("login error")
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                
                if (Auth.auth().currentUser != nil) {
                  // User is signed in.
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        let email = user.email ?? ""
                        GlobalVar.Email = email
                        
                        let db = Firestore.firestore()
                        let docRef = db.collection("users").document(uid)

                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                               // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"                            
                                let firstName = document.get("firstName") as! String
                               // let lastName = document.get("lastName") as! String
                                let phoneNumber = document.get("phoneNumber") as! String
                                    
                                GlobalVar.Name = (firstName)
                                GlobalVar.Number = phoneNumber.description
                                                                
                            } else {
                                print("Document does not exist")
                            }
                        }
                    }
                    let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
                    self.present(initViewController, animated: true, completion: nil)
                }

                
                
            }
        }
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
