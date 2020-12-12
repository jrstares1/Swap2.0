//
//  AccountViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/17/20.
//

import UIKit
import FirebaseAuth
import Firebase

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var uid = ""
    var numCells = 0
    var currentImage : UIImage?
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    var accountArray = ["Github", "Spotify", "Twitter"]
    var userAccountArray = [String]()
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var socialsTableView: UITableView!
    @IBOutlet var editButton: UIButton!
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
        auth()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        socialsTableView.delegate = self
        socialsTableView.dataSource = self
        socialsTableView.isScrollEnabled = true
        socialsTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserAccountTableViewCell")
        auth()
        
        profPic.layer.borderWidth=1.0
        profPic.layer.masksToBounds = false
        profPic.layer.borderColor = UIColor.white.cgColor
        profPic.layer.cornerRadius = profPic.frame.size.height/2
        profPic.clipsToBounds = true
        
        let imageData = userDefault.object(forKey: "profPic") as? Data ?? UIImage(systemName: "person.circle")!.pngData()
        profPic.image = UIImage(data: imageData!)
    }
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        profPic.image = image
        userDefault.setValue(image.pngData(), forKey: "profPic")
        
    }
    
    func setup(){
        editButton.backgroundColor = .clear
        editButton.layer.cornerRadius = 5
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.nameLabel.text = GlobalVar.Name
        self.emailLabel.text = GlobalVar.Email
        self.phoneLabel.text = GlobalVar.Number
    }
    func auth(){
        if (Auth.auth().currentUser != nil) {
          // User is signed in.
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let db = Firestore.firestore()
                db.collection("users/\(uid)/appData").getDocuments() {
                    (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting appData Documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if(!self.userAccountArray.contains(document.documentID)){
                                if(document.documentID != "Contact"){
                                    self.userAccountArray.append(document.documentID)
                                    self.socialsTableView.reloadData()
                                }
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
    
    
    override func reloadInputViews() {
        setup()
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
        return userAccountArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
