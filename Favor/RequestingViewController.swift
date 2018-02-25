//
//  RequestingViewController.swift
//  Favor
//
//  Created by Navjot Bola on 5/15/17.
//  Copyright © 2017 Bassi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestingViewController: UIViewController {
    var reference = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
