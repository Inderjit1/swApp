//
//  NewUserViewController.swift
//  SwApp
//
//  Created by Hedi Moalla on 2/23/18.
//  Copyright © 2018 Moalla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewUserViewController: UIViewController, UITextFieldDelegate {
    var theSkills = [String: Int]()
    var acceptable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New User Account"
        self.PasswordLabel.delegate = self
        ref = Database.database().reference()
        
    }

 
    
    //var ref: FIRDatabaseReference!
    @IBOutlet weak var UserIDLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    @IBOutlet weak var skillsLabel: UITextField!
    
    @IBOutlet weak var costLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var skillDisplay: UITextView!
    
   // @IBOutlet weak var skillsLabel: UITextField!
    var ref: DatabaseReference!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterAccount()
        return true
    }

    //enter accoutn funcion
    func enterAccount(){
        Work(self)
    }
    
    // add button
    func enterAddButton(){
        AddSkillsButton(self)
    }
    
    //display skills
    func DisplaySkills(){
        skillDisplay.text = ""
        for(key, element) in self.theSkills {
            print(key)
            print(element)
            var displayElement = "\(key) : \(element) points"
            skillDisplay.text = skillDisplay.text! + displayElement + "\n"
        }
    }
    
 
    func displayErrorMessage(alertController:UIAlertController){
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func AddSkillsButton(_ sender: Any) {
        for characters in (skillsLabel.text?.characters)!
        {
            if(skillsLabel.text != "" && !(characters < "a") && !(characters > "z"))
            {
                if(costLabel.text != "" && !(characters < "a") && !(characters > "z")){
                    acceptable = true
                }
            }
        }
        
        if(acceptable)
        {
            self.theSkills[skillsLabel.text!] = Int(costLabel.text!)
            print(self.theSkills)
            DisplaySkills()
            skillsLabel.text = ""
            costLabel.text = ""
        }
    }
    //function for add
    @IBAction func Work(_ sender: AnyObject) {
        
        var error = ""
        if (UserIDLabel.text == "" || PasswordLabel.text == "" || nameLabel.text == "" || (PasswordLabel.text?.count)! < 6) {error = "Blank Error"}
        if !((UserIDLabel.text?.hasSuffix("edu"))!){error = "Invalid Email"}
        
        switch error {
        case "Blank Error":
            let alertController = UIAlertController(title: "Error", message: "Please enter your name, skills email, and/or password", preferredStyle: .alert)
            displayErrorMessage(alertController: alertController)
        case "Invalid Email":
            let alertController = UIAlertController(title: "Error", message: "Please enter a valid school email", preferredStyle: .alert)
            displayErrorMessage(alertController: alertController)
        default:
            Auth.auth().createUser(withEmail: UserIDLabel.text!, password: PasswordLabel.text!) {(user, error) in
                if error == nil
                {
                    print("The sign-up was successful!\n")
                    user?.sendEmailVerification(completion: nil)
                    self.ref.child("Profile/\(Auth.auth().currentUser!.uid)").setValue(["Name" : "\(self.nameLabel.text!)", "Email ID":Auth.auth().currentUser?.email, "Skills": self.theSkills,"Points" : 50, "Pending Requests" : "", "Approved Requests": "", "Sent Requests" : ""])
                    self.performSegue(withIdentifier: "createdUser", sender: self)
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    self.displayErrorMessage(alertController: alertController)
                }
            }
            
        }
    }
   
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationvc =  segue.destination
        if let lgv = destinationvc as? LoginViewController
        {
            if segue.identifier == "createdUser"
            {
                lgv.ref = self.ref
            }
        }
    }

}
