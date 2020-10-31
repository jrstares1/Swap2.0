//
//  homePageViewController.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit
import FirebaseAuth
import Firebase

class homePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var uid = ""
    var numCells = 0
    var currentImage : UIImage?
    var accountArray = ["Github", "LinkedIn"]
    
    @IBOutlet weak var displayQR: UIImageView!
    @IBOutlet weak var socialsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home page view did load")
        
        socialsTableView.delegate = self
        socialsTableView.dataSource = self
        socialsTableView.isScrollEnabled = true
        let nib = UINib(nibName: "ActiveSocialsTableViewCell", bundle: nil)
        socialsTableView.register(nib, forCellReuseIdentifier: "ActiveSocialsTableViewCell")
        
        // Query Firebase for user info to display
        if (Auth.auth().currentUser != nil) {
          // User is signed in.
            let user = Auth.auth().currentUser
            if let user = user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                uid = user.uid
                let email = user.email
                
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(uid)
                let callingObject = self
                
                let appData = db.collection("users/\(uid)/appData").getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting appData Documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID)")
                            self.accountArray.append(document.documentID)
                            if (document.documentID == "Github") {
                                self.currentImage = #imageLiteral(resourceName: "Github")
                            }
                            if (document.documentID == "LinkedIn") {
                                self.currentImage = #imageLiteral(resourceName: "LinkedIn")
                            }
                            callingObject.numCells+=1
                            self.socialsTableView.reloadData()
                        }
                    }
//                    self.socialsTableView.reloadData()
                }

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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSocialsTableViewCell", for: indexPath) as! ActiveSocialsTableViewCell
        cell.socialLogo.image = UIImage(named: accountArray[indexPath.row])!
        cell.socialToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        cell.socialToggle.isEnabled = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = accountArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSocialsTableViewCell", for: indexPath) as! ActiveSocialsTableViewCell
        cell.socialToggle.isEnabled = true
        print(type)
        print("herereeeeeee")
        
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        print("switching state")
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    
    
    

}
