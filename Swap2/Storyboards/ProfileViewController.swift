//
//  ProfileViewController.swift
//  Swap2
//
//  Created by Justin Stares on 11/15/20.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    
    @IBAction func save(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    func buttonSetup(){
        saveButton.backgroundColor = .clear
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
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
