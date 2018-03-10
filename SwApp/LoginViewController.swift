//
//  LoginViewController.swift
//  SwApp
//
//  Created by Inderjit Bassi on 2/23/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {


    
    @IBOutlet weak var LoginIDLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordLabel.delegate = self
        navigationItem.title = "Welcome to SwApp!"
        ref = FIRDatabase.database().reference()
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var ref: FIRDatabaseReference!
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterButton()
        return true
    }
    
    func enterButton(){
        //LoginButton(sender: self)
    }
    
    //login button functionality
    @IBAction func LoginButton(_ sender: Any) {
        
        print("Email is \(LoginIDLabel.text)")
        print("Password is \(PasswordLabel.text)")
        
        //check empty fields
        if (self.LoginIDLabel.text == "" || self.PasswordLabel.text == "")
        {
            let alert = UIAlertController(title: "Error", message: "You did not enter anything for the Login ID/Password", preferredStyle: UIAlertControllerStyle.alert)
            let defaultaction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(defaultaction)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            // See if user has verified email
           /* if !(FIRAuth.auth()?.currentUser?.isEmailVerified)!
            {
               print("IN HERE")
                /*let alert = UIAlertController(title: "Error", message: "Email has not been verified", preferredStyle: UIAlertControllerStyle.alert)
                let defaultaction = UIAlertAction(title: "Email Verification", style: .default) {
                    (alertAction) in
                    
                    let textbox = alert.textFields![0] as UITextField
                }
                
                alert.addTextField{ (textField) in
                    textField.placeholder = "Enter email"
                }
                
                alert.addAction(defaultaction)
                present(alert, animated: true, completion: nil)*/
                FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: nil)
            }*/
            
            //call firebase
            FIRAuth.auth()?.signIn(withEmail: LoginIDLabel.text!, password: PasswordLabel.text!) { (user, error) in
                if error == nil
                {
                    print("Successfully logged in\n")
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarHome")
                    
                    self.present(vc!, animated: true, completion: nil)
                    
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let defaultaction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(defaultaction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
       let destinationvc =  segue.destination
        if let hvc = destinationvc as? HomepageViewController
        {
            if segue.identifier == "LoginSegue"
            {
               hvc.ref = self.ref
            }
    }
    }

   
}
