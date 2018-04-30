//
//  SearchDetailViewController.swift
//  SwApp
//
//  Created by Hedi Moalla on 2/23/18.
//  Copyright © 2018 Moalla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SearchDetailViewController: UIViewController {
    var databaseRef = Database.database().reference()
    var requestsArray = [String]()
    
    var otherUsersRequestsArray = [String]()

    @IBOutlet weak var showUser: UILabel!
    //var loggedInUser: FIRUser?

    var loggedInUserEmail: String!
    var loggedInUserName: String!
    
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
        print("Other user's Email:")
        print(otherUserEmail)
        skillLabel?.text = "is offering skill " +  otherUserSkill + " for " + otherUserCost + " points"

        self.databaseRef.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            print("What does it even look like?")
            print(snapshotValue)
            let name = snapshotValue?["Name"] as? String
            self.loggedInUserName = name
            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
            let email = snapshotValue?["Email ID"] as? String
            self.loggedInUserEmail = email
            if let skillsArray = snapshotValue?["Pending Requests"] as? NSArray {
                print("DOES THIS ARAY WORK")
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
        
        if thePoints < Int(otherUserCost)!
        {
            let alert = UIAlertController(title: "Error", message: "You don't have enough points for this transaction", preferredStyle: UIAlertControllerStyle.alert)
            let defaultaction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(defaultaction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            //extract uuid that matches email
            self.databaseRef.child("Profile").queryOrdered(byChild: "Email ID").queryEqual(toValue: otherUserEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                
                print("\n\n\n\nUser's Email:")
                print(self.otherUserEmail)
                print("\n\n")
                if (!snapshot.exists())
                {
                    
                    let emailIDAlertController = UIAlertController(title: "Error", message: "That email does not exist or was incorrectly entered", preferredStyle: .alert)
                }
                else
                {
                    for index in snapshot.children.allObjects
                    {
                        let snap = index as! DataSnapshot
                        if let children = snap.value as? [String: AnyObject]
                        {
                            if let skillsArray = children["Pending Requests"] as? NSArray {
                                self.otherUsersRequestsArray = skillsArray as! [String]
                                print("EXPAND")
                                print(self.requestsArray)
                            } else {
                                print("Cannot unwrap")
                            }
                        }
                    }
                    
                    if let test = snapshot.value as? [String: AnyObject] // Get the snapshot as a dictionary
                    {
                        for (key, value) in test
                        {
                            self.getkey = key
                        }
                    }
                    
                    //update array of pending requests in DB
                    
                    self.otherUsersRequestsArray.append(self.loggedInUserName + "-" + self.loggedInUserEmail +
                        " (\(self.otherUserSkill!) for \(self.otherUserCost!) points)")
                    print("The person that is stored in the database")
                    print(self.loggedInUserName + "-" + self.loggedInUserEmail)
                    self.databaseRef.child("Profile/\(self.getkey)").updateChildValues(["Pending Requests" : self.otherUsersRequestsArray])
                    
                    /*
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
                     self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Points").setValue(newPoints)
                     */
                }
                
            })
            
        }
            
        }
        
}
