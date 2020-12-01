//
//  SignUpViewController.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit
import FirebaseAuth
import Firebase
import PhoneNumberKit


class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements();

        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        errorLabel.alpha = 0; //make it transparent to begin
        
        //Styling elements
        Utilities.styleTextField(firstNameTextField)
        
        Utilities.styleTextField(lastNameTextField)

        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(phoneTextField)


        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)
        
        self.phoneTextField.withExamplePlaceholder = true
        self.phoneTextField.withFlag = true

        

    }
    
    
    

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: PhoneNumberTextField!
    
    
        
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    
    //if everything correct return nil
    //if not correct return error message
    func validateFields() -> String? {
        
        // Check that  fields are filled in
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPhone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        

        

        let phoneNumberKit = PhoneNumberKit()
        phoneNumberKit.isValidPhoneNumber(cleanedPhone)
  
                
        //the method below is from utilities
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // this means password isnt secure
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        if (Utilities.isValidEmail(cleanedEmail) == false){
            return "Not a valid email"
        }
        
        if (phoneNumberKit.isValidPhoneNumber(cleanedPhone) == false){
            return "Not a valid phone number"

        }
        
        
        //add correct email address method later here
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //User validation
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            
            // Create the user. Have to import to get this method
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
                // Check for errors. If it comes in as nil there was an error
                if err != nil {
                    self.showError("Error Creating User")
                    let alert = UIAlertController(title: "Error", message: "It appears this user already exists!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else {
                    // User creation successful!, now store first name and last name
                    if (Auth.auth().currentUser != nil) {
                      // User is signed in.
                        let user = Auth.auth().currentUser
                        if let user = user {
                          // The user's ID, unique to the Firebase project.
                          // Do NOT use this value to authenticate with your backend server,
                          // if you have one. Use getTokenWithCompletion:completion: instead.
                            let uid = user.uid
                            print("uid " + uid)
                            GlobalVar.Name = firstName + " " + lastName
                            GlobalVar.Number = phoneNumber
                            user.sendEmailVerification(completion: {error in
                                if error != nil{
                                    print("email welcome message was not send")
                                }
                            })
                            let db = Firestore.firestore()
                            db.collection("users").document(uid).setData(["firstName":firstName, "lastName":lastName, "phoneNumber":phoneNumber], merge: true){ (error) in
                                
                                if error != nil {
                                    // Show error message
                                    print(error ?? "no error")
                                    print("error adding user data")
                                    self.showError("Error adding user data. Database is most likely down ")
                                }
                                
                                
                            }
            
                        }
                        self.transitionToHome()

                    }else{
                        print("USER NULL. Should never get here however")
                    }
                    
                    }
                    

                }
                
            }
            
        }
        
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {

        let storyboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingViewController
        initViewController.modalPresentationStyle = .fullScreen
        self.present(initViewController, animated: true, completion: nil)
    
    }
    

}
