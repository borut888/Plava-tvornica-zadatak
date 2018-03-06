//
//  UserCollectionCellGrid.swift
//  PlavaTvornicaZadatakiOS
//
//  Created by Borut on 16/02/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import SDWebImage

class UserCollectionCellGrid: UICollectionViewCell {
    
    @IBOutlet weak var viewInCell: UIView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var viewGenderColor: UIView!
    @IBOutlet weak var imgGender: UIImageView!
    
    override func awakeFromNib() {
        userImg.layer.cornerRadius = userImg.frame.size.width/2
        userImg.clipsToBounds = true
        viewGenderColor.layer.cornerRadius = viewGenderColor.frame.size.width/2
        viewGenderColor.clipsToBounds = true
        viewInCell.layer.cornerRadius = 10
        viewInCell.addShadow(offset: CGSize.init(width: -2, height: 0), color: UIColor.black, radius: 3.0, opacity: 0.20)
        
    }
    
    // configuring cell for collectionView
    func configureCell(randomUsers: UserModel) {
        userName.text = randomUsers.name.firstName + " " + randomUsers.name.lastName
        userMail.text = randomUsers.userNumber
        userMail.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
        userName.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        userImg.sd_setImage(with: URL(string: randomUsers.picture.large))
        if randomUsers.gender == "male" {
            imgGender.image = UIImage(named: "male_icon")
            let blueColor = hexStringToUIColor(hex: "#007AFF")
            viewGenderColor.backgroundColor = blueColor
        } else if randomUsers.gender == "female"{
            imgGender.image = UIImage(named: "female_icon")
            let pinkColor = hexStringToUIColor(hex: "#D00284")
            viewGenderColor.backgroundColor = pinkColor
        }
    }
}
