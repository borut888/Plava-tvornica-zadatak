//
//  DetailVC.swift
//  PlavaTvornicaZadatakiOS
//
//  Created by Borut on 14/02/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import MessageUI
import Contacts
import ContactsUI
import SDWebImage

class DetailVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imgGender: UIImageView!
    @IBOutlet weak var viewRightBottomCorner: UIView!
    @IBOutlet weak var imgUserDetail: UIImageView!
    @IBOutlet weak var lblUserFirstAndLastName: UILabel!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var btnAdressStreet: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var lblUserAge: UILabel!
    @IBOutlet weak var viewLeftDownCorner: UIView!
    @IBOutlet weak var viewSmallLeftCorner: UIView!
    @IBOutlet weak var viewSmallRightCorner: UIView!
    @IBOutlet weak var viewUpLeftCorner: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgFlags: UIImageView!
    
    var currentUser : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)]
        
        //putting data on view objects
        imgUserDetail.sd_setImage(with: URL(string: (currentUser?.picture.large)!))
        lblUserFirstAndLastName.text = (currentUser?.name.firstName)! + " " + (currentUser?.name.lastName)!
        lblUserFirstAndLastName.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        btnPhoneNumber.setTitle("+385" + (currentUser?.userNumber)!, for: .normal)
        btnAdressStreet.setTitle(currentUser?.location.street, for: .normal)
        btnEmail.setTitle(currentUser?.email, for: .normal)
        setingUpFlags(flags: (currentUser?.location.state)!)
        
        // fixing fonts
        lblUserFirstAndLastName.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        btnSave.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        btnPhoneNumber.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        btnAdressStreet.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        btnEmail.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        
        //customizing buttons, labels and image
        btnEmail.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        btnAdressStreet.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        btnPhoneNumber.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        lblUserFirstAndLastName.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        lblUserAge.roundCorners(corners: [.topLeft, .bottomLeft], radius: 20)
        btnEmail.titleLabel?.adjustsFontSizeToFitWidth = true;
        btnAdressStreet.titleLabel?.adjustsFontSizeToFitWidth = true;
        imgUserDetail.layer.cornerRadius = imgUserDetail.frame.size.width/2
        imgUserDetail.clipsToBounds = true
        imgFlags.layer.cornerRadius = imgFlags.frame.size.width/2
        imgFlags.clipsToBounds = true
        
        //changing color for genders
        if currentUser?.gender == "male" {
            imgGender.image = UIImage(named: "male_icon")
            let blueColor = hexStringToUIColor(hex: "#007AFF")
            viewUpLeftCorner.backgroundColor = blueColor
            viewLeftDownCorner.backgroundColor = blueColor
            viewRightBottomCorner.backgroundColor = blueColor
            viewSmallLeftCorner.backgroundColor = blueColor
            viewSmallRightCorner.backgroundColor = blueColor
            lblUserFirstAndLastName.backgroundColor = blueColor
        } else if currentUser?.gender == "female"{
            imgGender.image = UIImage(named: "female_icon")
            let pinkColor = hexStringToUIColor(hex: "#D00284")
            viewUpLeftCorner.backgroundColor = pinkColor
            viewLeftDownCorner.backgroundColor = pinkColor
            viewRightBottomCorner.backgroundColor = pinkColor
            viewSmallLeftCorner.backgroundColor = pinkColor
            viewSmallRightCorner.backgroundColor = pinkColor
            lblUserFirstAndLastName.backgroundColor = pinkColor
        }
        
        //customizing views
        setingUpViews(views: viewLeftDownCorner)
        setingUpViews(views: viewRightBottomCorner)
        setingUpViews(views: viewSmallLeftCorner)
        setingUpViews(views: viewSmallRightCorner)
        setingUpViews(views: viewUpLeftCorner)
        
        //converting date to years
        let ageComponents = currentUser?.dob.components(separatedBy: "-")
        let dateDOB = Calendar.current.date(from: DateComponents(year:
            Int(ageComponents![0]), month: Int(ageComponents![1]), day:
            Int(ageComponents![2])))!
        lblUserAge.text = "\(dateDOB.age) yrs"
        
    }
    // option for calling user
    @IBAction func btnCallUser(_ sender: Any) {
        let phoneString = currentUser?.userNumber
        let url: NSURL = URL(string: "tel://+385" + (phoneString?.removingWhitespaces())!)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    // option for sending mail
    @IBAction func btnSendEmail(_ sender: Any) {
        let email = currentUser?.email
        let body = "Pozdrav od random usera"
        let coded = "mailto:\(String(describing: email))?body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: "mailto:" + coded!) {
            UIApplication.shared.open(url)
        }
    }
    
    // open mapVC and send data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigaton =  segue.destination as! MapVC
        navigaton.currentLocation = currentUser?.location.city
    }
    
    // saving user in phonebook
    @IBAction func btnSaveUser(_ sender: Any) {
        
        let con = CNMutableContact()
        con.givenName = (currentUser?.name.firstName)!
        con.familyName = (currentUser?.name.lastName)!
        let data : Data = UIImagePNGRepresentation(imgUserDetail.image!)!
        con.imageData = data
        con.phoneNumbers.append(CNLabeledValue(
            label: "Contact", value: CNPhoneNumber(stringValue: (currentUser?.phone)!)))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self as? CNContactViewControllerDelegate
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
    }
    
    // taking string and putting flag images
    func setingUpFlags(flags: String)  {
        switch flags {
        case "Cataluna":
            imgFlags.image = UIImage(named: "cataluna_State_icon")
        case "hessen":
            imgFlags.image = UIImage(named: "hessen_icon_flag")
        case "southland":
            imgFlags.image = UIImage(named: "southland_state_icon")
        case "valais":
            imgFlags.image = UIImage(named: "valais_state_icon")
        case "westmeath" :
            imgFlags.image = UIImage(named: "westmeath_state_icon")
        default:
            print("no flage")
        }
    }
    func setingUpViews(views: UIView)  {
        views.layer.cornerRadius = views.frame.width/2
        views.clipsToBounds = true
    }
    
}


