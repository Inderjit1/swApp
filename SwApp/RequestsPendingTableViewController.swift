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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        self.databaseRef.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["Name"] as? String
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //approve button
        let approve = UITableViewRowAction(style: .destructive, title: "Decline") { (action, indexPath) in
            print("Decline")
            var thisEmail = self.requestsArray[indexPath.row]
            self.requestsArray.remove(at: indexPath.row)
            print(self.requestsArray)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Pending Requests").setValue(self.requestsArray)

        }
        
        
        //decline button
        let decline = UITableViewRowAction(style: .normal, title: "Approve") { (action, indexPath) in
            print("Approve")
            var thisEmail = self.requestsArray[indexPath.row]
            self.requestsArray.remove(at: indexPath.row)
            print(self.requestsArray)
            self.approvedRequestsArray.append(thisEmail)
            print(self.approvedRequestsArray)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Pending Requests").setValue(self.requestsArray)

            self.databaseRef.child("Profile/\(Auth.auth().currentUser!.uid.replacingOccurrences(of: ".com", with: ""))/Approved Requests").setValue(self.approvedRequestsArray)


        }
        
        decline.backgroundColor = UIColor.blue
        
        return [approve, decline]
    }

}
