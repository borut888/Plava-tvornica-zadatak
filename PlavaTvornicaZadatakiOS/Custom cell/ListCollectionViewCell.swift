//
//  ListCollectionViewCell.swift
//  PlavaTvornicaZadatakiOS
//
//  Created by Borut on 17/02/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import SDWebImage
class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listImg: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserNumber: UILabel!
    @IBOutlet weak var viewOfList: UIView!
    @IBOutlet weak var genderColorVIew: UIView!
    @IBOutlet weak var imgGender: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblUserNumber.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
        listImg.layer.cornerRadius = listImg.frame.size.width/2
        listImg.clipsToBounds = true
        viewOfList.layer.cornerRadius = 35
        viewOfList.addShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 3.0, opacity: 0.25)
        
        // moving the view programmatically by device
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                genderColorVIew.frame.origin.x = 250
            case 1920, 2208:
                genderColorVIew.frame.origin.x = 340
            default:
                print("unknown")
            }
        }
        
    }
    
    // configuring cell for collectionView
    func configureCell(randomUsers: UserModel) {
        lblUserName.text = randomUsers.name.firstName + " " + randomUsers.name.lastName
        lblUserNumber.text = randomUsers.userNumber
        listImg.sd_setImage(with: URL(string: randomUsers.picture.large))
        if randomUsers.gender == "male" {
            imgGender.image = UIImage(named: "male_icon")
            let blueColor = hexStringToUIColor(hex: "#007AFF")
            genderColorVIew.backgroundColor = blueColor
        } else if randomUsers.gender == "female"{
            imgGender.image = UIImage(named: "female_icon")
            let color1 = hexStringToUIColor(hex: "#D00284")
            genderColorVIew.backgroundColor = color1
            
        }
    }
}

