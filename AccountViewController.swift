//
//  AccountViewController.swift
//  SwApp
//
//  Created by Inderjit Bassi on 2/23/18.
//  Copyright © 2018 Bassi. All rights reserved.
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
    var thePoints = 0
    var requestsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddSkillsLabel.delegate = self
        navigationItem.title = "My Account"
       
        print(AccountViewController.holdskills)
     
        reference = Database.database().reference()
        DisplayEmail()
        //display skills
    self.reference.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
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
        
    self.reference.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
        self.pointLabel?.text = "\(self.thePoints) points remaining"
            
            if let skillsArray = snapshotValue?["Approved Requests"] as? NSArray {
                self.requestsArray = skillsArray as! [String]
                print(self.requestsArray.count)
                self.requestsLabel?.text = "\(self.requestsArray.count) requests made"
            } else {
                print("cannot unwrap")
                self.requestsLabel?.text = "0 requests made"
            }
            
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var text = ""
    var reference: DatabaseReference!
    
    
    
   
    
    // Making this static is what keeps the same values when a new view is instantiated
    static var holdskills = [String]()
    private var acceptable = false
    @IBOutlet weak var AddSkillsLabel: UITextField!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var SkillsDisplay: UITextView!
    @IBOutlet weak var ValueDisplay: UITextField!
    @IBOutlet weak var NameDisplay: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var requestsLabel: UILabel!
    
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
         EmailLabel.text = Auth.auth().currentUser?.email
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
                self.reference.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Skills").setValue(self.theSkills)
                DisplaySkills()
                AddSkillsLabel.text = ""
                ValueDisplay.text = ""
        }
    }
  
}
