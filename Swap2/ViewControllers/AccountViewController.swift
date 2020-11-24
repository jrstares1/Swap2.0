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
    var transparentView = UIView()
    var tableView = UITableView()
    let height: CGFloat = 400
    var accountArray = ["Github", "Spotify", "Twitter"]
    //var userAccountArray = ["Github", "Instagram", "Facebook"]
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
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "Cell")
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
                //TODO: format phone number properly
                self.phoneLabel.text = GlobalVar.Number
                //TODO: figure out how to pass in the current user
                //todo: let firestore know who the current user is.
                
                let db = Firestore.firestore()
                db.collection("users/\(uid)/appData").whereField("phoneNumber", isEqualTo: GlobalVar.Number).getDocuments() {
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

    
    @IBAction func addAccounts(_ sender: Any) {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        self.view.addSubview(tableView)
        let screensize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screensize.height, width: screensize.width, height: height)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screensize.height - self.height, width: screensize.width, height: self.height)
        } , completion: nil)
    }
    
    @objc func onClickTransparentView(){
        let screensize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: screensize.height, width: screensize.width, height: self.height)
        } , completion: nil)
        self.viewDidLoad()
    }

    
    @IBAction func HelpTutorial(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
        initViewController.modalPresentationStyle = .fullScreen
        self.present(initViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func SignOut(_ sender: Any) {
        self.userDefault.set(false, forKey: "usersignedin")
        self.userDefault.synchronize()
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            self.present(initViewController, animated: true, completion: nil)
            
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
}
 

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.tableView){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AccountTableViewCell else{
                fatalError("Unable to deque cell")
            }
            cell.settingImage.image = UIImage(named: accountArray[indexPath.row])!
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountTableViewCell", for: indexPath) as? UserTableViewCell else{
                fatalError("Unable to deque cell")
            }
            cell.socialLogo.image = UIImage(named: userAccountArray[indexPath.row]) ?? nil
            cell.account = userAccountArray[indexPath.row]
            cell.delegate = self
            return cell
        }
        
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView){
            return accountArray.count
        }
        else{
            return userAccountArray.count
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView){
            let type = accountArray[indexPath.row]
            if(type == "Github"){
                let success = addGithub()
                //TODO: fix this. it's a little hard cody
                if (success){
                    print("succes adding github account. appending tablieview")
                    self.userAccountArray.append("Github")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
                
            }
            if(type == "Spotify"){
                let success = addSpotify()
                //TODO: fix this. it's a little hard cody
                if (success) {
                    self.userAccountArray.append("Spotify")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
               
            }
            if(type == "Twitter"){
                let success = addTwitter()
                //TODO: fix this. it's a little hard cody
                if (success) {
                    self.userAccountArray.append("Twitter")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
               
            }
            
   
        }
        else{
            let type = userAccountArray[indexPath.row]
        }
        
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




