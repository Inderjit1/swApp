//
//  PublicFeedCollectionViewCell.swift
//  SwApp
//
//  Created by Bassi on 3/24/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit

class PublicFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tradedWithUser: UILabel!
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
   
    
    
    /*override init(frame: CGRect){
        super.init(frame:frame)
        
     @IBOutlet weak var profileImage: UIImageView!
     setupViews()
    }
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   /* let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()*/
    
    func setupViews(){
        backgroundColor = UIColor.white
        /*addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))*/
    }
    */
    
    
}
