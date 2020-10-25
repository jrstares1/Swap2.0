//
//  AccountViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/17/20.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountViewController: UIViewController {

    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    var transparentView = UIView()
    var tableView = UITableView()
  
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

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func addAccounts(_ sender: Any) {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
            
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
        } , completion: nil)

    }
    
    @objc func onClickTransparentView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
        } , completion: nil)
    }
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBAction func Logout(_ sender: Any) {
        print("signing out")
        self.userDefault.set(false, forKey: "usersignedin")
        self.userDefault.synchronize()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
//        initViewController.modalTransitionStyle = .crossDissolve
        self.present(initViewController, animated: true, completion: nil)
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
