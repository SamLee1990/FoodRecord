//
//  FoodPhotoCollectionViewCell.swift
//  FoodRecord
//
//  Created by ζδΈζ on 2021/8/2.
//

import UIKit

class FoodPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodPhotoImageView: UIImageView!
    @IBOutlet weak var deletePhotoButton: UIButton!
    
    func setButtonCorner() {
        deletePhotoButton.clipsToBounds = true
        deletePhotoButton.layer.cornerRadius = 22
//        deletePhotoButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    
    
}
