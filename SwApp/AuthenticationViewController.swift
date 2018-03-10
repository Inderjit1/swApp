//
//  AuthenticationViewController.swift
//  SwApp
//
//  Created by Inderjit Bassi on 2/23/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()

    }

    //func ref() -> DatabaseReference!
    var ref: FIRDatabaseReference!
    @IBAction func confirmSend(_ sender: Any) {
        self.ref.child("Profile").queryOrdered(byChild: "Email ID").queryEqual(toValue: whichUserToRequestFrom.text).observe(.value, with: { (snapshot) in
         if (!snapshot.exists())
         {
            
            let emailIDAlertController = UIAlertController(title: "Error", message: "That username does not exist", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            emailIDAlertController.addAction(defaultAction)
            self.present(emailIDAlertController, animated: true, completion: nil)
         }
         else
         {
            //FIRAuth.auth().send
          }
            
        })
     
    }
    
    @IBOutlet weak var whichUserToRequestFrom: UITextField!

}
