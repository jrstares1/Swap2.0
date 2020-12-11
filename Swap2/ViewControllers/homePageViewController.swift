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
    
    let userDefault = UserDefaults.standard
    var uid = ""
    var numCells = 0
    var currentImage : UIImage?
    var userAccountArray = [String]()
    var transparentView = UIView()
    var tableView = UITableView()
    let height: CGFloat = 400
    var accountArray = ["Github", "Spotify", "Twitter", "Reddit"]
    
   
    @IBOutlet weak var displayQR: UIImageView!
    @IBOutlet weak var socialsTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonSetup()
        auth()
        socialsTableView.reloadData()
        swapListener()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        swapListener()
        buttonSetup()
        UserDefaults.standard.register(defaults: ["Contact" : true])
        UserDefaults.standard.register(defaults: ["Github" : true])
        UserDefaults.standard.register(defaults: ["Spotify" : true])
        UserDefaults.standard.register(defaults: ["Twitter" : true])
        UserDefaults.standard.register(defaults: ["Reddit" : true])
        socialsTableView.delegate = self
        socialsTableView.dataSource = self 
        socialsTableView.isScrollEnabled = true
        let nib = UINib(nibName: "ActiveSocialsTableViewCell", bundle: nil)
        socialsTableView.register(nib, forCellReuseIdentifier: "ActiveSocialsTableViewCell")
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "Cell")
        auth();
        socialsTableView.reloadData()
    }
    
    func auth(){
        userAccountArray.removeAll()
        let callingObject = self
    
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            if let user = user {
                uid = user.uid
                let db = Firestore.firestore()
                _ = db.collection("users").document(uid)
                //self.nameLabel.text = GlobalVar.Name
                let _: Void = db.collection("users/\(uid)/appData").getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        print("here Error Getting appData Documents: \(err)")
                        let alert = displayError(title: "Error Getting AppData Documents", message: "\(err)")
                        callingObject.present(alert, animated: true)
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
        
            if (uid != "" ) {
                displayQR.image = generateCode(uid: uid)
            } else {
                let ac = UIAlertController(title: "Failed to Receive User ID", message: nil, preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "Dismiss", style: .default)
                ac.addAction(submitAction)
                self.present(ac, animated: true)
            }
        }
    }
    
    func swapListener(){
        print("big brother is listening")
        var swapped = false
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let db = Firestore.firestore()
            
            db.collection("users/\(uid)/swapData")
                .addSnapshotListener { querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        let alert = displayError(title: "Error", message: "\(error!)")
                        self.present(alert, animated: true)
                        return
                    }
                    snapshot.documentChanges.forEach { diff in
                        if (diff.type == .added) {
                            swapped = true
                        }
                        if (diff.type == .modified) {
                            swapped = true
                        }
                        if (diff.type == .removed) {
                            swapped = true
                        }
                    }
                }
        }
        if(swapped){
            let ac = UIAlertController(title: "swap successful", message: nil, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Dismiss", style: .default)
            ac.addAction(submitAction)
            self.present(ac, animated: true)
        }
    }
    func buttonSetup(){
        nameLabel.text = GlobalVar.Name
        addButton.backgroundColor = .clear
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
    
    //change the state of account in db
    func changeState(_ type: String, _ state: Bool) {
        print("turning " + type + " " + state.description)
        if (Auth.auth().currentUser != nil) {
            let user = Auth.auth().currentUser
            if let user = user {
                uid = user.uid
                let db = Firestore.firestore()
                db.collection("users/\(uid)/appData").getDocuments() {  (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting appData Documents: \(err)")
                        let alert = displayError(title: "Error", message: "\(err)")
                        self.present(alert, animated: true)
                    }
                    else{
                        for document in querySnapshot!.documents {
                            if(document.documentID == type){
                                //TODO: test this out in new account
                                let dict = ["enabled":state]
                                db.collection("users").document(self.uid).collection("appData").document(type).setData(dict, merge: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //add account button func
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

   
}

extension homePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView){
            return accountArray.count
        }
        else{
            return userAccountArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.socialsTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSocialsTableViewCell", for: indexPath) as! ActiveSocialsTableViewCell
            cell.socialLogo.image = UIImage(named: userAccountArray[indexPath.row]) ?? nil
            cell.socialToggle.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            let type = userAccountArray[indexPath.row]
            let toggleState = UserDefaults.standard.bool(forKey: type)
            cell.socialToggle.isEnabled = true
            cell.socialToggle.isOn = toggleState
            cell.accountName = userAccountArray[indexPath.row]
            cell.socialToggle.tag = indexPath.row
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AccountTableViewCell else{
                fatalError("Unable to deque cell")
            }
            cell.settingImage.image = UIImage(named: accountArray[indexPath.row])!
            return cell
        }
        
    }

    @objc func switchChanged(mySwitch: UISwitch) {
        let state = mySwitch.isOn
        let type = userAccountArray[mySwitch.tag]
        self.userDefault.set(state, forKey: type)
        self.userDefault.synchronize()
        changeState(type, state)
        
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableView){
            let type = accountArray[indexPath.row]
            if(type == "Github"){
                let success = addGithub()
                if (success){
                    self.userAccountArray.append("Github")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
                
            }
            if(type == "Spotify"){
                let success = addSpotify()
                if (success) {
                    self.userAccountArray.append("Spotify")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
               
            }
            if(type == "Twitter"){
                let success = addTwitter()
                if (success) {
                    self.userAccountArray.append("Twitter")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
            }
            if(type == "Reddit"){
                let success = addReddit()
                if (success) {
                    self.userAccountArray.append("Reddit")
                    self.socialsTableView.reloadData()
                    self.viewDidLoad()
                }
            }
        }
        else{
           // let type = userAccountArray[indexPath.row]
        }
        
    }

    
}
