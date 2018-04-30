//
//  SlideInMenuBar.swift
//  SwApp
//
//  Created by Bassi on 4/24/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit
/*import Firebase
import FirebaseAuth
import FirebaseDatabase*/

class menubarItem: NSObject{
    let name: String
    let imagepath: String
    
    init(name: String, imagepath: String){
        self.name = name
        self.imagepath = imagepath
    }
}

class SlideInMenuBar: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var homepageviewcontroller: HomepageViewController?
 
    let blackout = UIView()
    let cellId = "cellId"
    
    let item: [menubarItem] = {
        return [menubarItem(name: "Settings", imagepath: "man-7.png"),
                menubarItem(name: "Points", imagepath: "icomoon-free_2014-12-23_coin-dollar_159_0_f1c40f_none")//,menubarItem(name: "Requests", imagepath: "ionicons_2-0-1_ios-person_159_0_3498db_none")]
        ]
    }()
    let menucollectionView: UICollectionView = {
        let mcv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        mcv.backgroundColor = UIColor.white
        return mcv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SlideInMenuBarCell
        
        let individualitem = item[indexPath.item]
        cell.setting = individualitem
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //Disappear()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackout.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.menucollectionView.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 0, height: self.menucollectionView.frame.height))
            }
        }) { (completed: Bool) in
            let selecteditem = self.item[indexPath.item]
            print(selecteditem)
            self.homepageviewcontroller?.navigationFromSlideInMenu(selecteditem: selecteditem)
            
        }
     
    }
    @objc func slidedropDown(){
        if let window = UIApplication.shared.keyWindow
        {
            
            blackout.backgroundColor = UIColor(white:0, alpha: 0.5)
            blackout.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(Disappear)))
            window.addSubview(blackout)
            window.addSubview(menucollectionView)
            menucollectionView.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: window.frame.width/2, height: window.frame.height))
            
            blackout.frame = window.frame
            blackout.alpha = 0
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackout.alpha = 1
                self.menucollectionView.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: self.menucollectionView.frame.width, height: self.menucollectionView.frame.height))
            }, completion: nil)
        }
    }
    
    @objc func Disappear(){
        UIView.animate(withDuration: 0.5, animations:
            {
                self.blackout.alpha = 0
                if let window = UIApplication.shared.keyWindow{
                    self.menucollectionView.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 0, height: self.menucollectionView.frame.height))
                }
        })
        
    }
    
/*  var ref: DatabaseReference!
    let userPoints: Int
    let requestsArray = [String]()
    let numberofRequests: Int
    
    func getUserInfo()
    {
        self.ref = Database.database().reference()
       self.ref.child("Profile").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue?["Name"] as? String
            //self.theName = name!
            //self.displayNameLabel?.text = "Hello \(self.theName)"
            
            let points = snapshotValue?["Points"] as? Int
            //self.userPoints = points!
            //self.pointsLabel?.text = "\(self.thePoints) points remaining"
            if let skillsArray = snapshotValue?["Approved Requests"] as? NSArray {
                //self.requestsArray = skillsArray as! [String]
                //self.numberofRequests = self.requestsArray.count
            } else {
               // self.numberofRequests = 0
            }
            
        })
    }*/
    
    override init(){ 
        super.init()
        menucollectionView.dataSource = self
        menucollectionView.delegate = self
        menucollectionView.register(SlideInMenuBarCell.self, forCellWithReuseIdentifier: cellId)
    }

}
