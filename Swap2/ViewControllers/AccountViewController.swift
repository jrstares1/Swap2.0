//
//  AccountViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/17/20.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountViewController: UIViewController{

    var uid = ""
    var numCells = 0
    var currentImage : UIImage?
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    var accountArray = ["Github", "Spotify", "Twitter"]
    var userAccountArray = [String]()
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var socialsTableView: UITableView!
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        auth()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        socialsTableView.delegate = self
        socialsTableView.dataSource = self
        socialsTableView.isScrollEnabled = true
        socialsTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserAccountTableViewCell")
        auth()
    }

    func auth(){
        if (Auth.auth().currentUser != nil) {
          // User is signed in.
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let email = user.email
                self.nameLabel.text = GlobalVar.Name
                self.emailLabel.text = email
                self.phoneLabel.text = GlobalVar.Number
                let db = Firestore.firestore()
                db.collection("users/\(uid)/appData").getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting appData Documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if(!self.userAccountArray.contains(document.documentID)){
                                self.userAccountArray.append(document.documentID)
                                self.socialsTableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }

    @IBAction func showPopup(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view )
        popOverVC.didMove(toParent: self)
        
    }
    
    @IBAction func HelpTutorial(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
        initViewController.modalPresentationStyle = .fullScreen
        self.present(initViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteProfile(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.destructive, handler: { action in
            let user = Auth.auth().currentUser
            user?.delete(completion: {error in
                if error != nil{
                    print("account deletion error")
                }
                else{
                    self.userDefault.set(false, forKey: "usersignedin")
                    self.userDefault.synchronize()
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
                    self.present(initViewController, animated: true, completion: nil)
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func SignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.userDefault.set(false, forKey: "usersignedin")
            self.userDefault.synchronize()
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            self.present(initViewController, animated: true, completion: nil)
        }
        catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}
 
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountTableViewCell", for: indexPath) as? UserTableViewCell else{
            fatalError("Unable to deque cell")
        }
        cell.socialLogo.image = UIImage(named: userAccountArray[indexPath.row]) ?? nil
        cell.account = userAccountArray[indexPath.row]
        cell.delegate = self
        return cell

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count " + userAccountArray.count.description)
        return userAccountArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension AccountViewController: MyCellDelegate {
    func didTapButton(account: String) {        
        //get confirmation to delete
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your " + account + " account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            //call API to delete
            deleteAccount(account)
            let index = self.userAccountArray.firstIndex(of: account)
            if(index != nil){
                //remove from the tableview
                self.userAccountArray.remove(at: index ?? 0)
            }
            self.socialsTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}




