//
//  AccountViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/17/20.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var uid = ""
    var numCells = 0
    var currentImage : UIImage?
    //var accountArray = [String]()
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    var transparentView = UIView()
    var tableView = UITableView()
    let height: CGFloat = 400
    var accountArray = ["Github", "LinkedIn"]
    var userAccountArray = [String]()
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.tableView){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AccountTableViewCell else{
                fatalError("Unable to deque cell")
            }
            cell.settingImage.image = UIImage(named: accountArray[indexPath.row])!
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSocialsTableViewCell", for: indexPath) as! ActiveSocialsTableViewCell
            cell.socialLogo.image = UIImage(named: userAccountArray[indexPath.row]) ?? nil
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
                githubButton()
            }
        }
        else{
            let type = accountArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveSocialsTableViewCell", for: indexPath) as! ActiveSocialsTableViewCell
            //cell.socialToggle.isEnabled = true
            print(type)
            print("herereeeeeee")
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
       
        auth()
        

    }
 
    override func viewDidLoad() {
        print("account view did load")
        super.viewDidLoad()
        
        socialsTableView.delegate = self
        socialsTableView.dataSource = self
        socialsTableView.isScrollEnabled = true
        let nib = UINib(nibName: "ActiveSocialsTableViewCell", bundle: nil)
        socialsTableView.register(nib, forCellReuseIdentifier: "ActiveSocialsTableViewCell")
        
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        auth()
        // Do any additional setup after loading the view.

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
                let appData = db.collection("users/\(uid)/appData").getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting appData Documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
//                            print("\(document.documentID)")
                            if(!self.userAccountArray.contains(document.documentID)){
                                self.userAccountArray.append(document.documentID)
                                print(self.userAccountArray)
                                print("check here")
                                //print(self.userAccountArray)
                                //callingObject.numCells+=1
                                self.socialsTableView.reloadData()
                            }
                            
                        }
                    }
                }
                }
            
        
        }
    }

    

        // Do any additional setup after loading the view.
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var socialsTableView: UITableView!
    
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
    }
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBAction func Logout(_ sender: Any) {
        print("signing out")
        self.userDefault.set(false, forKey: "usersignedin")
        self.userDefault.synchronize()
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
    //        initViewController.modalTransitionStyle = .crossDissolve
            self.present(initViewController, animated: true, completion: nil)
            
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
    func githubButton() {
        if (Auth.auth().currentUser != nil) {
          // User is signed in.
            let user = Auth.auth().currentUser
            if let user = user {
                
                user.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    // Handle error
                    print("Something is wrong with the token")
                    return;
                }
                GlobalVar.IdToken = idToken!
                print("Token Below2")
                print(GlobalVar.IdToken)
                

                // Send token to your backend via HTTPS
                let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/user")
                guard let requestUrl = url else { fatalError() }

                // Create URL Request
                var request = URLRequest(url: requestUrl)

                // Specify HTTP Method to use
                request.httpMethod = "GET"
                  
                // Request Header
                request.setValue("Bearer " + idToken!, forHTTPHeaderField: "Authorization")
                    

                // Send HTTP Request
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        
                // Check if Error took place
                if let error = error {
                    print("Error took place \(error)")
                        return
                }
                        
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }
                    
                //ADD Later if we get a 403 error stop.
                
                // Convert HTTP Response Data to a simple String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
                        
                }
                task.resume()

            
                //Now send to the url
                if let url = URL(string: "https://github.com/login/oauth/authorize?client_id=79be74dce9c0e8b91df0&scope=user:follow") {
                    UIApplication.shared.open(url)
                }
                
                //get code here and make put request
//                    let mySceneDelegate = self.view.window?.windowScene?.delegate
//                    let codeVar = (self.window?.windowScene?.delegate as! SceneDelegate).codeVariable

            }
                
                
        }
                } else {
                  // No user is signed in.
                    print("sign them out")
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




