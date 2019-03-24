//
//  message.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 22/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation

class message {
//    let userID = Auth.auth().currentUser?.uid
//    var femaleIds = [String]()
    var IDS = [String]()
    var messageBody = ""
    var sender :String = ""
    var receiverID : String!
    var timeStamp : Double = 0.0
    var sentMessage = ""
    var finalMatch =  [String]()
    var imageURL : String!
    var count : Int!
    var imageHeight : NSNumber!
    var imageWidth : NSNumber!
    var backButtonPressed : Int!
    var currentUserName: String!
    var femaleName : String!
    var femaleId : String!
    var userID : String!
    var profilePicURL = [String]()
    var gender : String!
    var age : Int!
    var badgeCount : Int = 0
}
