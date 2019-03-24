//
//  CONSTANTS.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 13/09/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation
import Firebase


class CONSTANTS {
    
    //DBPROVIDER
    static let MALES = "males"
    static let EMAIL = "email"
    static let PASSWORD = "password"
    static let DATA = "data"
    static let FEMALES = "Female"
    static let isSwipped = "Swipped"
    static let maleSwipped = "Male_Swipped"
    static let femaleSwipped = "Female_Swipped"
   
    //Handler
    
    
    var ref = Firebase.Database.database().reference(withPath: "users").child("male").observeSingleEvent(of: .value) { (snapshot) in
        
    }
    
    
    
    
    static let name = "NAME"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    
    
}
