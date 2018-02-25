//
//  AccountViewController.swift
//  Favor
//
//  Created by Bassi on 4/18/17.
//  Copyright © 2017 Bassi. All rights reserved.
// 

/********************
 
 
 Note: Need to still fix the problem where if I add a skill for user dev@yahoo.com such as mechanic, and if I loggout, and from there I loggin in with a user, say favor@gmail.com, and go back to the accountviewcontroller, it still shows the skill mechanic. The skill needs to be "saved" to only that one user.
 ********************/

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class AccountViewController: UIViewController, UITextFieldDelegate {
    var theSkills = [String: Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddSkillsLabel.delegate = self
        navigationItem.title = "My Account"
       
        print(AccountViewController.holdskills)
     
      
        reference = FIRDatabase.database().reference()
        DisplayEmail()
        
        //display skills
    self.reference.child("Profile").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["Name"] as? String
        self.NameDisplay.text = name
            if let skillsArray = snapshotValue?["Skills"] as? NSDictionary {
                self.theSkills = skillsArray as! [String : Int]
                print(self.theSkills)
                self.DisplaySkills()
            } else {
                print("cannot unwrap")
            }
        })

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var text = ""
    var reference: FIRDatabaseReference!
    
    
    
   
    
    // Making this static is what keeps the same values when a new view is instantiated
    static var holdskills = [String]()
    private var acceptable = false
    @IBOutlet weak var AddSkillsLabel: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var SkillsDisplay: UITextView!
    @IBOutlet weak var ValueDisplay: UITextField!
    @IBOutlet weak var NameDisplay: UILabel!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterSkill()
        return true
    }
    
    //enter skill box
    func enterSkill()
    {
       // AddSkillsButton(sender: self)
    }
    
    
    //email field
    func DisplayEmail()
    {
         EmailLabel.text = FIRAuth.auth()?.currentUser?.email
    }
    
    
    //skills field
    func DisplaySkills()
    {
        SkillsDisplay.text = ""
        for(key, element) in self.theSkills {
            print(key)
            print(element)
            var displayElement = "\(key) : \(element) points"
            SkillsDisplay.text = SkillsDisplay.text! + displayElement + "\n"
        }
    }

    //add skills button
    @IBAction func AddSkillsButton(_ sender: Any) {
        for characters in (AddSkillsLabel.text?.characters)!
        {
            //check if empty
            if(AddSkillsLabel.text != "" && !(characters < "a") && !(characters > "z"))
            {
                if(ValueDisplay.text != "" && !(characters < "a") && !(characters > "z")){
                    acceptable = true
                }
            }
        }
        
            if(acceptable)
            {
                //ok to add to DB
                self.theSkills[AddSkillsLabel.text!] = Int(ValueDisplay.text!)
                print(self.theSkills)
                self.reference.child("Profile/\(FIRAuth.auth()!.currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Skills").setValue(self.theSkills)
                DisplaySkills()
                AddSkillsLabel.text = ""
                ValueDisplay.text = ""
        }
    }
  
}
