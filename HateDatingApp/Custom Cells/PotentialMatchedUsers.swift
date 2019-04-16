//
//  PotentialMatchedUsers.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 13/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import Foundation
import Firebase

class potentialMatchedUsers {
    var name :String!
    var id : String!
    var profilePicURL : String!
    var pics = [String]()
    var names = [String]()
    var ids = [String]()
    var count = 0
    var percentageC : Float = 0.0
    var CurrentUsersDesription : String!
    var currentDescriptionWords = [String]()
    var snapshotKey : String!
}
