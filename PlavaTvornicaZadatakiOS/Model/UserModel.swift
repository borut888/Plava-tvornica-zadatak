//
//  UserModel.swift
//  PlavaTvornicaZadatakiOS
//
//  Created by Borut on 13/02/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit


struct Results : Decodable {
    let results : [UserModel]
}
struct UserModel: Decodable {
    let phone: String
    let gender: String
    let name : Names
    let location : Locations
    let email: String
    let dob: String
    let picture : Images
    
    var userNumber: String {
        let userNumberFixedString =  phone.replacingOccurrences(of: "-", with: "")
        return userNumberFixedString
    }
}

struct Names: Decodable {
    let first : String
    let last : String
    
    var firstName: String {
        let capitalLeter = first.capitalizingFirstLetter()
        return capitalLeter
    }
    var lastName: String {
        let capitalLeter = last.capitalizingFirstLetter()
        return capitalLeter
    }
}
struct Locations: Decodable {
    let street : String
    let city : String
    let state : String
}

struct Images : Decodable {
    let large : String
}

