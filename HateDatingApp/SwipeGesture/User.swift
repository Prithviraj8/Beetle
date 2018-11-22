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

    var firstNametextLable : String = ""
    var ref : DatabaseReference!
    var ref2 : DatabaseReference!


    func getLoggedInUserName(firstNametextLable: String) -> String {
        return firstNametextLable;
    }
    func save_Info_For_Male_User_who_Swipped_A_Female_User(name: String){
        let userID = Auth.auth().currentUser?.uid
        print("THE CURRENT USERS user ID is \(userID)")

        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("MSF").child(userID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            
            self.firstNametextLable = snapshotValue?["Name "] as? String ?? ""
            print("The name of the user is received \(self.firstNametextLable)")
            
            
            
            self.ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male Swipped Female").child(userID!)
            let usersChildRef = self.ref2.child(self.firstNametextLable)
//            usersChildRef.updateChildValues(["FNAME": name]) { (error, ref) in
//                if error != nil {
//                    print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
//
//                } else {
//                    print("The names of female users that the current logged in user swipped is SAVED")
//
//                }
//            }
            usersChildRef.setValue(name, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
                    
                } else {
                    print("The names of female users that the current logged in user swipped is SAVED")
                    
                }
            })
            //self.names.append(self.firstNametextLable)
        })

    }
    
    func save_Info_For_Female_User_who_Swipped_A_Male_User(name: String){
        let userID = Auth.auth().currentUser?.uid
        print("THE CURRENT USERS user ID is \(userID)")
        
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("FSM").child(userID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            
            self.firstNametextLable = snapshotValue?["Name "] as? String ?? ""
            print("The name of the user is received \(self.firstNametextLable)")
            
            
            
//            self.ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Female Swipped Mmale").child(userID!)
            self.ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Female Swipped Mmale").child(userID!)

            let usersChildRef = self.ref2.child(self.firstNametextLable).childByAutoId()
//            usersChildRef.updateChildValues(["FNAME": name]) { (error, ref) in
//                if error != nil {
//                    print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
//
//                } else {
//                    print("The names of female users that the current logged in user swipped is SAVED")
//                    //   print("The female name swipped by the logged in user is \(self.femaleName)")
//
//                }
//            }
            usersChildRef.setValue(name, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
                    
                } else {
                    print("The names of male users that the current logged in user swipped is SAVED")
                    
                }
            })
            //self.names.append(self.firstNametextLable)
        })
        
    }
   
    
}
//    func updateChildRef(name : String) {
//        let userID = Auth.auth().currentUser?.uid
//
//        let usersChildRef = ref.child("users").child("Male Swipped Female").child(userID!).child(firstNametextLable)
//        usersChildRef.updateChildValues(["FNAME": name]) { (error, ref) in
//            if error != nil {
//                print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
//                
//            } else {
//                print("The names of female users that the current logged in user swipped is SAVED")
//                //   print("The female name swipped by the logged in user is \(self.femaleName)")
//                
//            }
//        }
//    }
