//
//  SlideInMenuBarCell.swift
//  SwApp
//
//  Created by Bassi on 4/24/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit

class SlideInMenuBarCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
            menubarImage.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }
    
    var setting: menubarItem? {
        didSet {
            nameLabel.text = setting?.name
            if let nameofimage = setting?.imagepath{
                menubarImage.image = UIImage(named: nameofimage)//?.withRenderingMode(.alwaysTemplate)
                //menubarImage.tintColor = UIColor.darkGray
            }
           
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        return label
    }()
    
    let menubarImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named:"man-7.png")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
        //addSubview(nameLabel)
        //addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
    }
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(menubarImage)
        
        //addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        //addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: menubarImage, nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: menubarImage)
        addConstraint(NSLayoutConstraint(item: menubarImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
       // addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8[v1]|", views: menubarImage, nameLabel)
       // addConstraintsWithFormat(format: "V:|[v0]||", views: nameLabel)
       // addConstraintsWithFormat(format: "V:|[v0(30)]|", views: menubarImage)
        
       // addConstraint(NSLayoutConstraint(item: menubarImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This code was used from Let's Build that app
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
