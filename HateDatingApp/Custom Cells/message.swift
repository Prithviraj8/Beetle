//
//  message.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 22/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation
import UIKit

class message {
//    let userID = Auth.auth().currentUser?.uid
//    var femaleIds = [String]()
    var IDS = [String]()
    var messageBody : String?
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
    var maleId : String!
    var maleName: String!
    var userID : String!
    var profilePicURL = [String]()
    var gender : String!
    var age : Int!
    var badgeCount : Int = 0
    var chatMessageLength : Int = 0
    var inputTextFieldHeight : CGFloat!
    var pics = [UIImage]()
    var messageCount : Int = 0
    var profilePic : String!
    var oneMatch_Name : String!
    var messageImageURL : String!
}
