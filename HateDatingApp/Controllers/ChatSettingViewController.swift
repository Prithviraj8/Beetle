//
//  ChatSettingViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 24/03/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class ChatSettingViewController: UIViewController {
    @IBOutlet weak var blockToggleButton: UISwitch!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageViewX!
    
    var messages = message()
    var gender : String = ""
    var firstNameTextLabel : String = ""
    var profilePic : String = ""
    var profilePicURL = [String]()
    var IDs = [String]()
    var names = [String]()
    var id : String = ""
    var userID = Auth.auth().currentUser?.uid
    var name = ""
    var age : Int!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("PASSED INFO IS \(gender), \(firstNameTextLabel), \(id)")
        let blockRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(gender).child(userID!).child(firstNameTextLabel).child(id)
        blockRef.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as! NSDictionary
            if let blocked = snapshotValue["Blocked "] as? String {
                if blocked == "True" {
                    self.blockToggleButton.isOn = true
                }else{
                    self.blockToggleButton.isOn = false
                }
            }else{
                self.blockToggleButton.isOn = false

            }
        }
        print("AGE IS \(age)")
        
        if gender == "Male"{
            let ageRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child(id)
            ageRef.observe(.value) { (snap) in
                let snapValue = snap.value as! NSDictionary
                let age = snapValue["Age "] as! Int
                self.ageLabel.text = String(age)
                
            }
        }else{
            let ageRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child(id)
            ageRef.observe(.value) { (snap) in
                let snapValue = snap.value as! NSDictionary
                let age = snapValue["Age "] as! Int
                self.ageLabel.text = String(age)
        }
       
    }
       
        nameLabel.text = name
        profilePicImageView.layer.cornerRadius = 15
        profilePicImageView.layer.masksToBounds = true
        profilePicImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let url = URL(string: profilePic){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Failed while fetching images : \(error?.localizedDescription)")
                    return
                }else {
                    DispatchQueue.main.async {
                        self.profilePicImageView?.image = UIImage(data: data!)
                    }
                }
                
            }).resume()
        }
    }
 
    @IBAction func backButton(_ sender: Any) {
        if gender == "Male" {
            performSegue(withIdentifier: "backToMaleChatting", sender: self)
        }else{
            performSegue(withIdentifier: "backToFemaleChatting", sender: self)

        }
    }
    
    @IBAction func reportAbusePressed(_ sender: Any) {
        performSegue(withIdentifier: "ReportAbuse", sender: self)
        
    }
    
    @IBAction func blockToggle(_ sender: UISwitch) {
        
        if blockToggleButton.isOn == true {
            let blockRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(gender).child(userID!).child(firstNameTextLabel).child(id)
            blockRef.updateChildValues(["Blocked ": "True"])
        }else{
            let blockRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(gender).child(userID!).child(firstNameTextLabel).child(id)
            blockRef.updateChildValues(["Blocked ": "False"])
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMaleChatting" {
            let VC = segue.destination as! ChatLogTableViewController
            VC.femaleNames = names
            VC.IDs = IDs
            VC.femaleName = name
            VC.firstNametextLable = firstNameTextLabel
            VC.profilePic = profilePic
            VC.femaleId = id
            VC.profilePicURL = profilePicURL
            VC.age = age

        }else if segue.identifier == "backToFemaleChatting" {
            let VC = segue.destination as! ChatViewFemaleViewController
            VC.maleNames = names
            VC.Ids = IDs
            VC.maleName = name
            VC.firstNametextLable = firstNameTextLabel
            VC.profilePic = profilePic
            VC.maleId = id
            VC.profilePicURL = profilePicURL
            VC.age = age
        }else if segue.identifier == "ReportAbuse"{
            let VC = segue.destination as! ReportAbuseViewController
            VC.names = names
            VC.IDs = IDs
            VC.name = name
            VC.firstNameTextLabel = firstNameTextLabel
            VC.profilePic = profilePic
            VC.id = id
            VC.profilePicURL = profilePicURL
            VC.age = age
            VC.gender = gender
        }
        
        
        
    }
    
    
}
