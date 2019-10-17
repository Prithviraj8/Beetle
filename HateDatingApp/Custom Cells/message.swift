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
    var imageUrl : String!
    var count : Int = 0
    var imageHeight : NSNumber!
    var imageWidth : NSNumber!
    var backButtonPressed : Int!
    var currentUserName: String!
    var Name : String!
    var ID : String!
    var maleId : String!
    var maleName: String!
    var userID : String!
    var profilePicURL = [String]()
    var gender : String!
    var age : Int!
    var badgeCount : Int = 0
    var chatMessageLength : Int = 0
    var inputTextFieldHeight : CGFloat!
    var messageCount : Int = 0
    var profilePic : String!
    var oneMatch_Name : String!
    var messageImageURL = [String]()
    var typeOfCell : UITableViewCell!
//    var chatMessage : ChatMessage!
    

}


import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text "] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
        
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
}
