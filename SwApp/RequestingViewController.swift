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
        navigationItem.title = "Requests"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha:1)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
