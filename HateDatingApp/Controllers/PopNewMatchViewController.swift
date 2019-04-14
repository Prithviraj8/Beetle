//
//  PopNewMatchViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 07/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class PopNewMatchViewController: UIViewController {

    var profilePicURL = [String]()
    var IDs = [String]()
    var firstNametextLable : String = ""
    var Id : String = ""
    var Name : String = ""
    var userID = Auth.auth().currentUser?.uid
    var messages = message()
    var ref : DatabaseReference!
    var NAMES : [names] = [names]()
    var femaleNames = [String]()
    var age : Int!
    var gender : String = ""
    var pic : String!
    
    
    @IBOutlet weak var Views: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ProfilePic: UIImageViewX!
    @IBOutlet weak var OK: UIButtonX!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for id in IDs {
            if gender == "Male"{
        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(id)
        badgeCountRef.observe(.value) { (snap) in
            if let snapshotValue = snap.value as? NSDictionary{
                if let badge = snapshotValue["Badge added "] as? String {
                }else{
                    badgeCountRef.updateChildValues(["Badge added ": "True"])

                }
            }
        }
                
    }else{
         
                let FemalebadgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(id)
                FemalebadgeCountRef.observe(.value) { (snap) in
                    if let snapshotValue = snap.value as? NSDictionary{
                        if let badge = snapshotValue["Badge added "] as? String {
                        }else{
                            FemalebadgeCountRef.updateChildValues(["Badge added ": "True"])
                        
                        }
                    }
                }
            }
        }
        print("AGE IN POP IS \(firstNametextLable)")
        if let url = URL(string: pic){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Failed while fetching images : \(error?.localizedDescription)")
                    return
                }else {
                    DispatchQueue.main.async {

                        self.ProfilePic.image = UIImage(data: data!)
                    }
                }
                
            }).resume()
        }
        
        print("PROFILE PIC SIZE IS \(ProfilePic.frame.height) && \(ProfilePic.frame.width)")
        name.text = Name
        ProfilePic.translatesAutoresizingMaskIntoConstraints = false
        ProfilePic.layer.masksToBounds = true
        ProfilePic.layer.borderWidth = 2
        ProfilePic.layer.borderColor = UIColor.gray.cgColor
        ProfilePic.layer.cornerRadius = 24
        
//        ProfilePic.contentMode = .scaleAspectFill
//
        name.translatesAutoresizingMaskIntoConstraints = false
        name.layer.masksToBounds = true
        name.layer.cornerRadius = 12
        
        OK.setGradientBackground(colorOne: Colors.brightOrange, colorTwo: Colors.orange)
        
    }

    @IBAction func DismissPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
