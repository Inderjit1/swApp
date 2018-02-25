//
//  RequestViewController.swift
//  Favor
//
//  Created by Bassi on 5/13/17.
//  Copyright © 2017 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RequestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        getPendingRequests()
        
    }
    var emails = ""
    func getPendingRequests()
    {
        self.ref.child("Profile/\(FIRAuth.auth()!.currentUser!.uid)/Pending Requests").observe(.value, with: { (snapshot) in
            print(snapshot)
            print(snapshot.childrenCount)
            
            // var emails = ""
            for children in snapshot.children.allObjects
            {
                print(children)
                let snap = children as! FIRDataSnapshot
                //  print("HERE")
                //  print(snap)
                //  print(snap.childrenCount)
                if let values = snap.value as? String
                {
                    print("Print the values object")
                    self.emails = self.emails + values + "\n"
                    print(values)
                }
            }
            self.pendingRequests.text =  self.emails
        })
    }
    
    func setApprovedRequests()
    {
        
        let separate = pendingRequests.text!
        let newlineseparation = separate.characters.split(separator: "\n").map(String.init)
        for values in newlineseparation
        {
            self.ref.child("Profile/\(FIRAuth.auth()!.currentUser!.uid)/Approved Requests").childByAutoId().setValue(values)//pendingRequests.text)
        }
        
    }
    
    //@IBOutlet weak var pendingRequests: UITextField!
    @IBOutlet weak var pendingRequests: UITextView!
    
    @IBOutlet weak var searchUser: UITextField!
    
    //@IBOutlet weak var pendingRequests: UITextView!
    
    
    @IBOutlet weak var approvedRequests: UITextView!
    
    
    @IBAction func approveButton(_ sender: Any) {
        approvedRequests.text = pendingRequests.text
        setApprovedRequests()
        
        var test = pendingRequests.text!
        //self.ref.child("Profile/\(pendingRequests.text)/Pending Requests").setValue("") // Perry's email pending request is removed
        self.ref.child("Profile").queryOrdered(byChild: "Email ID").queryEqual(toValue: test.replacingOccurrences(of: "\n", with: "")).observe(.value, with: { (snapshot) in
            print(snapshot)
            print(self.pendingRequests.text)
            if(snapshot.exists())
            {
                if let test = snapshot.value as? [String: AnyObject] // Get the snapshot as a dictionary
                {
                    for (key, value) in test{
                        print(key) // The key actually equals the requested user's unique ID
                        self.ref.child("Profile/\(key)/Sent Requests").setValue("")
                        
                    }
                }
                
            }
            
        })
        
        self.ref.child("Profile/\(FIRAuth.auth()!.currentUser!.uid)/Pending Requests").setValue("")
        
        pendingRequests.text = ""
        
        
        
    }
    
    var ref: FIRDatabaseReference!
    @IBAction func makeRequest(_ sender: Any) {
        self.ref.child("Profile").queryOrdered(byChild: "Email ID").queryEqual(toValue: searchUser.text).observeSingleEvent(of: .value, with: { (snapshot) in
            if (!snapshot.exists())
            {
                
                let emailIDAlertController = UIAlertController(title: "Error", message: "That email does not exist or was incorrectly entered", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                emailIDAlertController.addAction(defaultAction)
                self.present(emailIDAlertController, animated: true, completion: nil)
            }
            else
            {
                var getkey: String = ""
                if let test = snapshot.value as? [String: AnyObject] // Get the snapshot as a dictionary
                {
                    for (key, value) in test
                    {
                        print(key) // The key actually equals the requested user's unique ID
                        getkey = key
                        //self.ref.child("Profile/\(key)/Pending Requests").setValue(FIRAuth.auth()!.currentUser!.email)
                        // self.ref.child("Profile/\(FIRAuth.auth()!.currentUser!.uid)/Sent Requests").setValue(self.searchUser.text)
                    }
                }
                print("What is getkey: \(getkey)")
                self.ref.child("Profile/\(getkey)/Pending Requests").childByAutoId().setValue(FIRAuth.auth()!.currentUser!.email)
                self.ref.child("Profile/\(FIRAuth.auth()!.currentUser!.uid)/Sent Requests").setValue(self.searchUser.text)
            }
            
        })
        
    }
    
}
