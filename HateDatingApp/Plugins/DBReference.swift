//
//  DBReference.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 13/09/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    var dbref: DatabaseReference {
        return Database.database().reference().child("users")
    }
    var maleRef: DatabaseReference {
        return dbref.child("Male").child(CONSTANTS.name)
    }
    var femaleRef: DatabaseReference {
        return dbref.child("Female").child(CONSTANTS.name)
    }
    var requestRef: DatabaseReference {
        return dbref.child(CONSTANTS.isSwipped)
    }
    var requestAcceptedRef: DatabaseReference {
        return dbref.child(CONSTANTS.femaleSwipped)
    }
    var requestAcceptedRef2: DatabaseReference {
        return dbref.child(CONSTANTS.maleSwipped)
    }
    
}





