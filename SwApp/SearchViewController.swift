//
//  SearchViewController.swift
//  SwApp
//
//  Created by Inderjit Bassi on 2/23/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SearchViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        displaySearch()
        ref = FIRDatabase.database().reference()
        self.searchBar.delegate = self
        //let userid = FIRAuth.auth()?.currentUser?.uid
        displayResults.isEditable = false
        filtersearch()
    }
    
    func filtersearch(){
        // This version gets all of the users that have skills
        self.ref.child("Profile").queryOrdered(byChild: "Skills").observe(.value, with: { (snapshot) in
            
            print("TEST")
            print(snapshot)  // Snap(Profile) - display all users
            print("END OF TEST")
            if(!snapshot.exists()){ self.displayResults.text = "Not found, try searching for a skill"} // If the user searched for something else other than a skill, then print out not found
            else
            {
                for test in snapshot.children.allObjects // Gets all of the users
                {
                    let snap = test as! FIRDataSnapshot // Make each one a snapshot
                    print(snap)                         // Print each snapshot
                    if let children = snap.value as? [String: AnyObject] // Extract the fields
                    {
                        let name = children["Name"] as! String
                        let email = children["Email ID"] as! String
                        let skills = children["Skills"] as! String
                        if skills.contains(self.searchresult.lowercased()) // If user search matches skill
                        {
                            self.searchwasfound = true
                            print("It does contain it")
                            self.displayResults.text = self.displayResults.text! + "Name: \(name)" + "\n" + "Email: \(email)" + "\n\n"
                           // self.displayResults.text = self.displayResults.text! + "\(email)"
                        }
                    }
                }
            }
        })
        
    }
    
    
    //@IBOutlet weak var displayResults: UITextField!
    @IBOutlet weak var SearchResultsLabel: UILabel!
    //@IBOutlet weak var displayResults: UILabel!
    @IBOutlet weak var displayResults: UITextView!
    
    var searchresult = ""
    var ref: FIRDatabaseReference!
    var searchwasfound = false
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func requestSkill(_ sender: Any) {
        if searchwasfound
        {
            performSegue(withIdentifier: "requestSkill", sender: sender)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
    
    func search() {
        SearchResultsLabel.text = "Results for " + searchBar.text!
        searchresult = searchBar.text!
        self.displayResults.text = ""
        filtersearch()
    }
    
    func displaySearch(){
        SearchResultsLabel.text = "Results for " + searchresult
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationvc = segue.destination
        if let authvc = destinationvc as? AuthenticationViewController
        {
            if segue.identifier == "requestSkill"
            {
                authvc.ref = self.ref
            }
        }
    }


}
