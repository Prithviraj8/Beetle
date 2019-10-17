//
//  UserTableViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 05/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase



class UserTableViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
 
    @IBOutlet weak var matchesTableView: UITableView!
    
    
    var profilePicURL = [String]()
    var IDs = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    var firstNametextLable : String = ""
    var ID : String = ""
    var NAME : String = ""
    let userID = Auth.auth().currentUser?.uid
    var messages = message()
    var ref : DatabaseReference!
    var NAMES : [names] = [names]()
    var MatchedNames = [String]()
    var age : Int!
    var gender : String = ""
    var currentUsersGender : String = ""
    var newMessageReceived : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchesTableView.delegate = self
        matchesTableView.dataSource = self
        matchesTableView.clipsToBounds = true
        navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        matchesTableView.register(UserCell.self, forCellReuseIdentifier: "Cell")
        matchesTableView.separatorStyle = .none        
    }
    
    @IBAction func backButton(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "BackToMainPage", sender: self)
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return MatchedNames.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//         Configure the cell...
    
//        cell.selectionStyle = UITableViewCellSelectionStyle.none

        let name = MatchedNames[indexPath.row]
        let profilePic = profilePicURL[indexPath.row]
        let id = IDs[indexPath.row]
        if newMessageReceived == true {
//            print("NEW MESSAGE FOR HER \(femaleName)")

            if NAME == cell.textLabel?.text {

                UIView.animate(withDuration: 2, animations: {
                    cell.setGradientBackground(colorOne: Colors.lightBlue, colorTwo: Colors.darkBlue)
                }) { (true) in
                    UIView.animate(withDuration: 1, animations: {
                        cell.backgroundColor = .white
                    })
                }
            }
        }
        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(userID!).child(firstNametextLable).child(id)
        badgeCountRef.observe(.value) { (snap) in
            if let snapshotValue = snap.value as? NSDictionary{
                if let badge = snapshotValue["Badge added "] as? String {
                    print("CELL ALREADY GLOWN")
            }else{
                    if name == cell.textLabel?.text {
                        
                        UIView.animate(withDuration: 2, animations: {
                            badgeCountRef.updateChildValues(["Badge added ": "True"])
                    
                            cell.backgroundColor = .gray
                            }) { (true) in
                                    UIView.animate(withDuration: 1, animations: {
                                        cell.backgroundColor = .white
                                })
                        }
                    }
                }
            }
        }
        
        
        
        
        if let url = URL(string: profilePic){
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("Failed while fetching images : \(error?.localizedDescription)")
                return
            }else {
                DispatchQueue.main.async {
                    cell.profileImageView.contentMode = .scaleAspectFill
                    cell.profileImageView.image = UIImage(data: data!)
                }
            }

        }).resume()
            
            
            var ReceivedMessageTime = [Date]()
            var SentMessageTime = [Date]()

            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child((Auth.auth().currentUser?.uid)!).child(firstNametextLable).child(id).child(name).child("Messages")
                ref.observe(.childAdded) { (snapshot) in
                    
                    if  let snapshotValue = snapshot.value as? NSDictionary {
                    
                    if let ReceivedTimeStamp = snapshotValue["Time Stamp Received "] as? Double {

                            let ReceivedTimeStampDate = Date(timeIntervalSince1970: ReceivedTimeStamp )
                            ReceivedMessageTime.append(ReceivedTimeStampDate)
        
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "hh:mm:ss a"
                            
                            cell.timeLabel.text = dateFormatter.string(from: ReceivedMessageTime.last!)
                        
                    
                    }else if let SentTimeStamp = snapshotValue["Time Stamp "] as? Double {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "hh:mm:ss a"
                            let sentTimeStampDate = Date(timeIntervalSince1970: SentTimeStamp)
                            SentMessageTime.append(sentTimeStampDate)
                            cell.timeLabel.text = dateFormatter.string(from: SentMessageTime.last!)

                    }
                    
            }
        }
            
            
        cell.textLabel?.text = name
    }
       
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell selected")

        performSegue(withIdentifier: "goToChat", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {
            if let indexPath = self.matchesTableView.indexPathForSelectedRow {
                let VC = segue.destination as! ChatLogController
                let femaleName = MatchedNames[indexPath.row]
                let Id = IDs[indexPath.row]
                let profilePic = profilePicURL[indexPath.row]
                print("THE MALE NAME PASSED IS \(firstNametextLable)")
                VC.firstNametextLable = firstNametextLable
                VC.name = femaleName
                VC.id = Id
                VC.names = MatchedNames
                VC.IDs = IDs
                VC.profilePicURL = profilePicURL
                VC.profilePic = profilePic
                VC.age = age
                VC.gender = gender
                VC.currentUsersGender = currentUsersGender
            }
        }
        
        if segue.identifier == "BackToMainPage" {
//            dismiss(animated: true, completion: nil)
            let VC = segue.destination as! SearchPartnerViewController
            VC.firstNametextLable = firstNametextLable
            VC.IDs = IDs
            VC.gender = gender
            VC.CurrentUserGender = currentUsersGender

        }
        
    }

}
