//
//  Handler.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 02/09/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation
import Firebase

class Handler  {
    private static let _instance = Handler();
    
    var male = ""
    var female = ""
    var male_id = ""
    var female_id = ""
    static var Instance: Handler {
        return _instance
    }
    
    func observeMessagesForMale(latitude: Double, longitude: Double) {
        //Female swipes on a male pic
        
        let data: Dictionary<String, Any> = [CONSTANTS.name: male, CONSTANTS.LATITUDE: latitude, CONSTANTS.LONGITUDE: longitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
    }
    
    func observeMessagesForFemale(latitude: Double, longitude: Double) {
        //male swipes on a male pic
        
        let data: Dictionary<String, Any> = [CONSTANTS.name: female, CONSTANTS.LATITUDE: latitude, CONSTANTS.LONGITUDE: longitude]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
    }
    
}
