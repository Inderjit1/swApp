//
//  HomepageViewController.swift
//  SwApp
//
//  Created by Inderjit Bassi on 2/23/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomepageViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var requestsLabel: UILabel!
    var theName = ""
    var thePoints = 0
    var theRequests = 0
    var requestsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        //get profile for current use and info
        self.ref.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            
            let name = snapshotValue?["Name"] as? String
            self.theName = name!
            self.displayNameLabel?.text = "Hello \(self.theName)"

            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
            self.pointsLabel?.text = "\(self.thePoints) points remaining"

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
    
    //reload info
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        
        self.ref.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            
            let name = snapshotValue?["Name"] as? String
            self.theName = name!
            self.displayNameLabel?.text = "Hello \(self.theName)"
            
            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
            self.pointsLabel?.text = "\(self.thePoints) points remaining"
            
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
    }
    
    var ref: DatabaseReference!
    
    //log out button
    @IBAction func LogOutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil { // Why do we need to check this?
            do{
                try Auth.auth().signOut()
                let lvc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.present(lvc!, animated: true, completion: nil)
                
            } catch let signouterror as NSError{
                print(signouterror.localizedDescription)
            }
        }
    }
    

}
