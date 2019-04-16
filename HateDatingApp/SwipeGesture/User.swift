//
//  User.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 12/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class User {
    var names = [String]()
    var name : String = ""
    var firstNametextLable : String = ""
    var ref : DatabaseReference!
    var ref2 : DatabaseReference!
    var recevierID = message()
    var id : String = ""
    var age : Int!
    var COUNT : Int!
    var imageTapped: String!
    var gender : String!
    
    func save_Info_For_Male_User_who_Swipped_A_Female_User(name: String,Id: String){
        let userID = Auth.auth().currentUser?.uid
        print("THE CURRENT USERS user ID is \(userID)")

        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("MSF").child(userID!)

        ref.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
            
                self.firstNametextLable = (snapshotValue["Name "] as! String)
                print("The name of the user is received \(self.firstNametextLable)")
            
            
            
                self.ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female").child(userID!)

                let usersChildRef = self.ref2.child(self.firstNametextLable).child(Id).child(name)
                usersChildRef.updateChildValues(["Added ": "True"])

        }
        })

    }
    
    func save_Info_For_Female_User_who_Swipped_A_Male_User(name: String,Id: String){
        let userID = Auth.auth().currentUser?.uid
        let messages = message()
        print("THE CURRENT USERS user ID is \(userID)")
        messages.sender = userID!
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("FSM").child(userID!)

        ref.observe(.value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
            
                self.firstNametextLable = (snapshotValue["Name "] as! String)
                print("The name of the user is received \(self.firstNametextLable)")
            
            
            
                self.ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male").child(userID!)

                let usersChildRef = self.ref2.child(self.firstNametextLable).child(Id).child(name)
                usersChildRef.updateChildValues(["Added ": "True"])

            }
        })
    }
}
