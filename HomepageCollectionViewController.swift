//
//  HomepageCollectionViewController.swift
//  
//
//  Created by Bassi on 3/23/18.
//

import UIKit
import Firebase
import FirebaseDatabase

//private let reuseIdentifier = "Cell"

class HomepageCollectionViewController: UICollectionViewController
{
   
    
    var ref = Database.database().reference()
    var stringcount = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Welcome to SwApp!"
        
       // UINavigationBar.appearance().barTintColor = UIColor(red:51/255, green: 90/255, blue: 149/255, alpha: 1)
        
        ref.child("Profile").queryOrdered(byChild: "Skills").observe(.value, with: {(snapshot) in
            var count = 0;
            
            for test in snapshot.children.allObjects
            {
                // Make each one a snapshot
                let snap = test as! DataSnapshot
                // Extract the fields
                if let children = snap.value as? [String: AnyObject]
                {
                    let name = children["Name"] as! String
                    let email = children["Email ID"] as! String
                    self.stringcount.append(name)
                    print("AT LEAST IT'S HERE")
                    print(name)
                    
                }
            }
        })
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.register(publicfeedcell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("IN CollectionView")
        print(stringcount.count)
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PublicFeedCollectionViewCell
        
        print("HERE?")
        cell.backgroundColor = UIColor.black
    
        // Configure the cell
    
        return cell
    }
}

class publicfeedcell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        print("INSIDE PUBLIC FEED CELL")
    }
    
    func setupViews(){
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
