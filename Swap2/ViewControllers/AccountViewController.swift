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
    let height: CGFloat = 400
    
 
  
    override func viewDidLoad() {

        
        print("account view did load")
        super.viewDidLoad()
        
        
        tableView.isScrollEnabled = true
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        // Do any additional setup after loading the view.
        if (Auth.auth().currentUser != nil) {
          // User is signed in.
            let user = Auth.auth().currentUser
            if let user = user {
                
//                print("here6")
//                print(UserDefaults.standard.string(forKey: "Code"))

              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
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


                        self.nameLabel.text = (firstName + " " + lastName)
                        self.emailLabel.text = email
                        
                    } else {
                        print("Document does not exist")
                    }
                }
            }
//                let docRef = db.collection("users").whereField("uid", isEqualTo: uid)
//
//                docRef.getDocuments { (snapshot, error) in
//                        guard let snapshot = snapshot else {
//                            print("Error \(error!)")
//                            return
//                        }
//                        for document in snapshot.documents {
//                            let documentId = document.documentID
//                            print("doc id " + documentId) //This print all objects
//                            let firstname = document.get("firstname") as! String
//                            print("first name " + firstname)
//                            let lastname = document.get("lastname") as! String
//                            print("last name " + lastname)
//
//                            //setting the labels
//                            self.nameLabel.text = firstname + " " + lastname
//                            self.emailLabel.text = email
//
//
//                            }
//                        }
//
//                } else {
//                  // No user is signed in.
//                    print("sign them out")
//                }
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
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
    
    
    
    @IBAction func githubButton(_ sender: Any) {
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




//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//}
