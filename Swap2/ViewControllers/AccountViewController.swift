//
//  AccountViewController.swift
//  Swap2
//
//  Created by Gillian Dibbs Laming on 10/17/20.
//

import UIKit

class AccountViewController: UIViewController {

    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Logout(_ sender: Any) {
        print("signing out")
        self.userDefault.set(false, forKey: "usersignedin")
        self.userDefault.synchronize()
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
