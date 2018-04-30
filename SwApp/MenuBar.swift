//
//  MenuBar.swift
//  SwApp
//
//  Created by Bassi on 4/23/18.
//  Copyright © 2018 Bassi. All rights reserved.
//

import UIKit

class MenuBar: NSObject {
    let blackout = UIView()
    
    let menucollectionView: UICollectionView = {
        let mcv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        mcv.backgroundColor = UIColor.white
        return mcv
    }()
    
    //         menucollectionView.dataSource = self
    //         menucollectionView.delegate = self
    
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
    
    override init(){
        super.init()
    }

}
