//
//  FirstViewController.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit

class FirstViewController: UIViewController {
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if userDefault.bool(forKey: "usersignedin") {
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
            self.present(initViewController, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        //Styling elements
        Utilities.styleFilledButton(signUpButton)
        
        Utilities.styleHollowButton(loginButton)

    }
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func loginTapped(_ sender: Any) {
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
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
