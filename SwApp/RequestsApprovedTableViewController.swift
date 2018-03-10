//
//  RequestsApprovedTableViewController.swift
//  SwApp
//
//  Created by Casey Reyes on 2/23/18.
//  Copyright © 2018 Reyes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RequestsApprovedTableViewController: UITableViewController {
    var databaseRef = FIRDatabase.database().reference()
    var requestsArray = [String]()
    var requestsArray2 = ["email1", "email2"]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        self.databaseRef.child("Profile").child((FIRAuth.auth()?.currentUser!.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["Name"] as? String
            if let skillsArray = snapshotValue?["Approved Requests"] as? NSArray {
                self.requestsArray = skillsArray as! [String]
                print(self.requestsArray)
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
        // #warning Incomplete implementation, return the number of rows
        return requestsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell!
        cell?.textLabel?.text = requestsArray[indexPath.row]
        // Configure the cell...
        
        return cell!
    }
    
}
