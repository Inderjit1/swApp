//
//  SearchDetailViewController.swift
//  Favor
//
//  Created by Navjot Bola on 5/15/17.
//  Copyright © 2017 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchDetailViewController: UIViewController {
    var databaseRef = FIRDatabase.database().reference()
    var requestsArray = [String]()

    @IBOutlet weak var showUser: UILabel!
    var loggedInUser: FIRUser?
    var loggedInUserCost: Int!
    var loggedInUserEmail: Int!
    var otherUserSkill: String!
    var otherUserEmail: String!
    var otherUserCost: String!
    var otherUserName: String!
    @IBOutlet weak var skillLabel: UILabel!
    var thePoints = 0
    var theOtherUsersPoints = 0
    var getkey: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        showUser?.text = otherUserName
        skillLabel?.text = "is offering skill " +  otherUserSkill + " for " + otherUserCost + " points"

        self.databaseRef.child("Profile").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["Name"] as? String
            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
            if let skillsArray = snapshotValue?["Pending Requests"] as? NSArray {
                self.requestsArray = skillsArray as! [String]
                print(self.requestsArray)
            } else {
                print("cannot unwrap")
            }
        })

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func requestButton(_ sender: Any) {
        
        //extract uuid that matches email
        self.databaseRef.child("Profile").queryOrdered(byChild: "Email ID").queryEqual(toValue: otherUserEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists())
            {
                
                let emailIDAlertController = UIAlertController(title: "Error", message: "That email does not exist or was incorrectly entered", preferredStyle: .alert)
            }
            else
            {
                if let test = snapshot.value as? [String: AnyObject] // Get the snapshot as a dictionary
                {
                    for (key, value) in test
                    {
                        self.getkey = key
                    }
                }
            
                //update array of pending requests in DB
                self.requestsArray.append(self.otherUserEmail)
                self.databaseRef.child("Profile/\(self.getkey.replacingOccurrences(of: ".com", with: ""))/Pending Requests").setValue(self.requestsArray)
                
                
                //get points from otherUser
                self.databaseRef.child("Profile").child(self.getkey).observeSingleEvent(of: .value, with: {(snapshot) in
                    let snapshotValue = snapshot.value as? NSDictionary
                    
                    let points = snapshotValue?["Points"] as? Int
                    self.theOtherUsersPoints = points!
                    
                    //update other users points
                    let newOtherPoints = self.theOtherUsersPoints + Int(self.otherUserCost)!
                    print("******")
                    print(self.theOtherUsersPoints)
                    print(newOtherPoints)
                    print("******")
                    self.databaseRef.child("Profile/\(self.getkey.replacingOccurrences(of: ".com", with: ""))/Points").setValue(newOtherPoints)
                })
                
                //modify points
                let newPoints = self.thePoints - Int(self.otherUserCost)!
                
                //update current user points
                self.databaseRef.child("Profile/\(FIRAuth.auth()!.currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Points").setValue(newPoints)
            }
            
        })

    }
    
}
