//
//  RequestsPendingTableViewController.swift
//  SwApp
//
//  Created by Casey Reyes on 2/23/18.
//  Copyright © 2018 Reyes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RequestsPendingTableViewController: UITableViewController {
    var databaseRef = Database.database().reference()
    var requestsArray = [String]()
    var approvedRequestsArray = [String]()
    var getkey: String = ""
    var pointsHolder: Int = 0
    var loggedinuserPoints: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        self.databaseRef.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["Name"] as? String
            let points = snapshotValue?["Points"] as? Int
            self.loggedinuserPoints = points!
            if let skillsArray = snapshotValue?["Pending Requests"] as? NSArray {
                self.requestsArray = skillsArray as! [String]
                print(self.requestsArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("cannot unwrap")
            }
            if let skillsArray = snapshotValue?["Approved Requests"] as? NSArray {
                self.approvedRequestsArray = skillsArray as! [String]
                print(self.approvedRequestsArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("cannot unwrap")
            }
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //configure cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell!
        cell?.textLabel?.text = requestsArray[indexPath.row]
        return cell!
    }
    
    func acceptPointsFromUser(email: String, pointstoreturn: Int){
        self.databaseRef.child("Profile").queryOrdered(byChild: "Email ID").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("\nINSIDE RETURN POINTS")
            for index in snapshot.children.allObjects
            {
                let snap = index as! DataSnapshot
                if let children = snap.value as? [String: AnyObject]
                {
                    let points = children["Points"] as! Int
                    print("\nWhat is the old guys points \(points)")
                    self.pointsHolder = points
                }
            }
            
            if let test = snapshot.value as? [String: AnyObject] // Get the snapshot as a dictionary
            {
                for (key, value) in test
                {
                    self.getkey = key
                }
            }
            
            //Deduct Points From the user requesting the skill
            self.databaseRef.child("Profile/\(self.getkey)").updateChildValues(["Points" : self.pointsHolder -  pointstoreturn])
       
            // Add the points to the user who is accepting the skill
            self.databaseRef.child("Profile").child(Auth.auth().currentUser!.uid).updateChildValues(["Points": self.loggedinuserPoints + pointstoreturn])
        })
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //decline button
        let decline = UITableViewRowAction(style: .destructive, title: "Decline") { (action, indexPath) in
            print("Decline")
            let thisEmail = self.requestsArray[indexPath.row]
            self.requestsArray.remove(at: indexPath.row)
            print(self.requestsArray)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Pending Requests").setValue(self.requestsArray)

        }
        
        
        //approve button
        let approve = UITableViewRowAction(style: .normal, title: "Approve") { (action, indexPath) in
            print("Approve")
            var thisEmail = self.requestsArray[indexPath.row]
            
            print("\n\nthisEmail is\n\n")
            print(thisEmail)
            let getResult = thisEmail.split(separator:"-")
            let getEmailResult = getResult[1].split(separator:" ") // Gets the Email
            print("Email of returned user is")
            print(getEmailResult[0])
            
            let pointvalue = Int(thisEmail.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
            self.acceptPointsFromUser(email: String(getEmailResult[0]), pointstoreturn: pointvalue!)
            
            
            self.requestsArray.remove(at: indexPath.row)
            print(self.requestsArray)
            self.approvedRequestsArray.append(thisEmail)
            print(self.approvedRequestsArray)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Pending Requests").setValue(self.requestsArray)

            self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Approved Requests").setValue(self.approvedRequestsArray)


        }
        
        approve.backgroundColor = UIColor.red
        decline.backgroundColor = UIColor.blue
        
        return [decline, approve]
    }

}
