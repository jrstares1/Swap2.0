//
//  PopUpViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 12/1/20.
//

import UIKit
import FirebaseAuth
import Firebase

class PopUpViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        showAnimate()
        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
       
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
        
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
   
    @IBAction func deleteProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.destructive, handler: { action in
        deleteAccount("Self")
        self.userDefault.set(false, forKey: "usersignedin")
        self.userDefault.synchronize()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
        self.present(initViewController, animated: true, completion: nil)

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
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
    
    @IBAction func help(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
        initViewController.modalPresentationStyle = .fullScreen
        self.present(initViewController, animated: true, completion: nil)
    }
}
