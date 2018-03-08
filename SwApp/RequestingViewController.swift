//
//  RequestingViewController.swift
//  SwApp
//
//  Created by Hedi Moalla on 2/23/18.
//  Copyright © 2018 Moalla. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestingViewController: UIViewController {
    var reference = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
