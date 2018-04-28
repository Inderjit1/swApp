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
import Foundation

class HomepageViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var requestsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var theName = ""
    var thePoints = 0
    var count = -1
    var theRequests = 0
    var requestsArray = [String]()
    var nameArray = [String]()
    var approvedRequestsArray = [String]()
    let hellobutton = UIButton()
    let barbuttonleftitem = UIBarButtonItem()
    var objectsArray = [Objects]()
    
    var dropdownbuttons = [UIBarButtonItem]()
    
    var stackview = UIStackView()

    struct Objects {
        var collectionviewname: String!
        var latestapprovedRequest: String!
        var lastUserTradedWith: String!
        //var id: String!
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.navigationItem.title = "Welcome to SwApp!"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self,action: #selector(addTapped))
        
        //self.collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.collectionView.backgroundColor = UIColor.yellow
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha:1)
    
        
        let testframe: CGRect = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: view.frame.width, height:100))
        //(0,200,320,200)
        var dl: UIView = UIView(frame: testframe)
        dl.backgroundColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1)
        dl.alpha = 0.5

        //get profile for current use and info
        //print(ref.description())
        
        self.ref.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            //print("HERE")
            //print(Auth.auth().currentUser!.displayName)
            //print("AFTER HERE")
            let name = snapshotValue?["Name"] as? String
            self.theName = name!
            self.displayNameLabel?.text = "Hello \(self.theName)"

            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
            self.pointsLabel?.text = "\(self.thePoints) points remaining"

            if let skillsArray = snapshotValue?["Approved Requests"] as? NSArray {
                self.requestsArray = skillsArray as! [String]
                //print(self.requestsArray.count)
                self.requestsLabel?.text = "\(self.requestsArray.count) requests made"
            } else {
                print("cannot unwrap")
                self.requestsLabel?.text = "0 requests made"
            }
        
        })
     
       
        self.ref.child("Profile").queryOrdered(byChild: "Skills").observe(.value, with: {(snapshot) in
            for test in snapshot.children.allObjects
            {
                // Make each one a snapshot
                let snap = test as! DataSnapshot
                // Extract the fields
                if let children = snap.value as? [String: AnyObject]
                {
                    //print("INSIDE ALL USERS")
                    let name = children["Name"] as! String
                    let email = children["Email ID"] as! String
                    if let arArray = children["Approved Requests"] as? NSArray {
                       // print("WHAT IS THE NAME")
                       // print(name)
               
                         self.approvedRequestsArray = arArray as! [String]
                        //print("WHAT IS THE APPROVED REQUESTS ARRAY")
                        // PUT The OBJECTS ARAY HERE
                        let result = self.approvedRequestsArray.last?.split(separator:"-")

                        //print("What is the result of the split")
                        //print(result![0])
                        //print(result![1])
                        
                        self.objectsArray.append(Objects(collectionviewname: name, latestapprovedRequest: self.approvedRequestsArray.last, lastUserTradedWith: String(result![0])))
                        //print(self.approvedRequestsArray)
                    } else {
                        print("cannot unwrap")
                    }

                    
                    /*if let approvedRequestsArray = children["Approved Requests"] as? NSArray{
                        print("AFTER AFTER EMAIL")
                        self.displayRequests = approvedRequestsArray as! [Int: String]
                        let lazyMapCollection = self.displayRequests.values
                        let approvedRequestUserName = Array(lazyMapCollection)
                        var stringArray = approvedRequestUserName.map{
                            String($0)
                        }
                        
                        print("What is String Array: ")
                        print(stringArray)
                        self.count = self.count + 1
                    }*/
    

                    self.nameArray.append(name)
                   
                    //self.approvedRequestsArray.append(String(describing: self.approvedRequestsArray.last))
                    //self.count = self.count + 1
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
         
            }
        })
        DispatchQueue.main.async {
            //print("RELOADED")
            self.collectionView.reloadData()
        }
        
        
     
    }

    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
       // print("TRYING TO ADD VIEW")
       // view.backgroundColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1)
        return view
    }()
    
    /*static func createButton(title: String, image: String) -> UIButton{
        return button
    }
    */
    
    let testButton: UIButton = {
       let button = UIButton()
        button.setTitle("CHECK", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    @objc func addTapped(){
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
    
    let slideinmenubar = SlideInMenuBar()
    
    @objc func dropDown(){
      slideinmenubar.slidedropDown()
    }
 
    func tabbarButton (name: String){
       // let image = UIImage(named:"icomoon-free_2014-12-23_coin-dollar_159_0_f1c40f_none.png")
       // hellobutton.setImage(image, for: .normal)
        hellobutton.setTitle("Hello " + name + "!", for: .normal)
        hellobutton.frame = CGRect(x:0.0, y:0.0, width: 4.0, height: 4.0)
        
        //hellobutton.addTarget(self, action: #selector(dropDown), for: .touchUpInside)
        barbuttonleftitem.customView = hellobutton
        
      
        //self.navigationItem.leftBarButtonItem = barbuttonleftitem
        dropdownbuttons.append(UIBarButtonItem(title: "Test", style: .plain, target: self,action: #selector(dropDown)))
        dropdownbuttons.append(UIBarButtonItem(title: "Does this work", style: .plain, target: self,action: #selector(dropDown)))
        
       
       
        
        //self.navigationItem.leftBarButtonItems = dropdownbuttons
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Hello " + name + "!", style: .plain, target: self,action: #selector(dropDown))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print(self.nameArray.count)
        print("INSIDE SECTION PATH")
        //print(nameArray.count)
        //return nameArray.count
       // print(objectsArray.count)
        return objectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PublicFeedCollectionViewCell
   
        
        for i in objectsArray{
            //print("LJAFLJSDFLJSFL")
            //print(i.collectionviewname)
        }
        cell.nameLabel.numberOfLines = 2
        cell.backgroundColor = UIColor.blue
        
        let attributedText = NSMutableAttributedString(string: objectsArray[indexPath.row].collectionviewname + " Just traded with! " + objectsArray[indexPath.row].lastUserTradedWith, attributes:
            [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
  
        attributedText.append(NSMutableAttributedString(string: "\n" + "Just Traded With", attributes:
         [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white]))
        
        let customizedText = NSMutableAttributedString(string: objectsArray[indexPath.row].lastUserTradedWith, attributes:
            [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        //attributedText.append(NSAttributedString(string: "\nDecember 18 + San Francisco + ",attributes:[NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 19)!])
        
        cell.nameLabel.attributedText = attributedText
        
        //cell.nameLabel.text = nameArray[indexPath.row]
        cell.profileImage.image = UIImage(named:"home-7.png")
        cell.leftArrow.image = UIImage(named: "red-circular-arrow-clipart-1-left.png")
        cell.rightArrow.image = UIImage(named:"red-circular-arrow-clipart-1.png")
        
        cell.tradedWithUser.attributedText = customizedText
        
        
        //print("PUBLIC FEED CELL")
        // print(nameArray[indexPath.item].count)
        return cell
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
           // self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.theName + "!", style: .plain, target: self,action: #selector(self.dropDown))
            self.tabbarButton(name: self.theName)
            
            let points = snapshotValue?["Points"] as? Int
            self.thePoints = points!
            self.pointsLabel?.text = "\(self.thePoints) points remaining"
            
            if let skillsArray = snapshotValue?["Approved Requests"] as? NSArray {
                self.requestsArray = skillsArray as! [String]
                //print(self.requestsArray.count)
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

}
