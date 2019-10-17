////
////  UserTableFemaleTableViewController.swift
////  HateDatingApp
////
////  Created by Prithviraj Murthy on 24/12/18.
////  Copyright © 2018 Prithviraj Murthy. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class UserTableFemaleTableViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
//
//    
//    let searchController = UISearchController(searchResultsController: nil)
//    var firstNametextLable : String = ""
//    var maleName : String = ""
//    var maleId : String = ""
//    let userID = Auth.auth().currentUser?.uid
//    var NAMES : [names] = [names]()
//    var ref : DatabaseReference!
//    var maleNames = [String]()
//    var Ids = [String]()
//    var profilePicURL = [String]()
//    var gender : String = ""
//    var currentUsersGender : String = ""
//    var age : Int!
//    var newMessageReceived : Bool = false
//
//    @IBOutlet weak var matchesTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        matchesTableView.delegate = self
//        matchesTableView.dataSource = self
//        matchesTableView.clipsToBounds = true
//        navigationItem.searchController = searchController
////        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        matchesTableView.separatorStyle = .none
//        matchesTableView.register(UserCell.self, forCellReuseIdentifier: "Cell")
//    }
//
//    @IBAction func backButton(_ sender: Any) {
////        dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "backToFemalePartner", sender: self)
//    }
//    // MARK: - Table view data source
//
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        // #warning Incomplete implementation, return the number of rows
//
//        return maleNames.count
//    }
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
//
//        //         Configure the cell...
////        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        let name = maleNames[indexPath.row]
//        let profilePic = profilePicURL[indexPath.row]
//        let id = Ids[indexPath.row]
//        //        print("PICS AREE \(profilePicURL)")
//        if newMessageReceived == true {
//            if cell.textLabel?.text == maleName {
//                UIView.animate(withDuration: 2, animations: {
//                    cell.setGradientBackground(colorOne: Colors.lightBlue, colorTwo: Colors.darkBlue)
//                }) { (true) in
//                    UIView.animate(withDuration: 1, animations: {
//                        cell.backgroundColor = .white
//                    })
//                }
//            }
//        }
//        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(userID!).child(firstNametextLable).child(id)
//        badgeCountRef.observe(.value) { (snap) in
//            if let snapshotValue = snap.value as? NSDictionary{
//                if let badge = snapshotValue["Badge added "] as? String {
//                    print("CELL ALREADY GLOWN")
//                }else{
//                    if name == cell.textLabel?.text {
//
//                        UIView.animate(withDuration: 2, animations: {
//                            badgeCountRef.updateChildValues(["Badge added ": "True"])
//
//                            cell.backgroundColor = .gray
//                        }) { (true) in
//                            UIView.animate(withDuration: 1, animations: {
//                                cell.backgroundColor = .white
//                            })
//                        }
//                    }
//                }
//            }
//        }
//
//
//        if let url = URL(string: profilePic){
//
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print("Failed while fetching images : \(error?.localizedDescription)")
//                    return
//                }else {
//                    DispatchQueue.main.async {
//                        cell.profileImageView.contentMode = .scaleAspectFill
//                        cell.profileImageView.image = UIImage(data: data!)
//                    }
//                }
//
//            }).resume()
//
//
//            var ReceivedMessageTime = [Date]()
//            var SentMessageTime = [Date]()
//
//            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child((Auth.auth().currentUser?.uid)!).child(firstNametextLable).child(id).child(name).child("Messages")
//            ref.observe(.childAdded) { (snapshot) in
//
//                let snapshotValue = snapshot.value as! NSDictionary
//
//                if let ReceivedTimeStamp = snapshotValue["Time Stamp Received "] as? Double {
//
//                    let ReceivedTimeStampDate = Date(timeIntervalSince1970: ReceivedTimeStamp )
//                    ReceivedMessageTime.append(ReceivedTimeStampDate)
//
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "hh:mm:ss a"
//
//                    cell.timeLabel.text = dateFormatter.string(from: ReceivedMessageTime.last!)
//
//
//                }else if let SentTimeStamp = snapshotValue["Time Stamp "] as? Double {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "hh:mm:ss a"
//                    let sentTimeStampDate = Date(timeIntervalSince1970: SentTimeStamp)
//                    SentMessageTime.append(sentTimeStampDate)
//                    cell.timeLabel.text = dateFormatter.string(from: SentMessageTime.last!)
//
//                }
//            }
//            cell.textLabel?.text = name
//
//        }
//        return cell
//
//    }
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
//
//
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Cell selected")
//        print("Name selected \(maleName)")
//        performSegue(withIdentifier: "goToChat", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToChat" {
//            if let indexPath = self.matchesTableView.indexPathForSelectedRow {
//                let VC = segue.destination as! ChatLogController
//                let maleName = maleNames[indexPath.row]
//                let id = Ids[indexPath.row]
//                let profilePic = profilePicURL[indexPath.row]
//                VC.firstNametextLable = firstNametextLable
//                VC.name = maleName
//                VC.id = id
//                VC.names = maleNames
//                VC.IDs = Ids
//                VC.profilePicURL = profilePicURL
//                VC.profilePic = profilePic
//                VC.gender = gender
//                VC.currentUsersGender = currentUsersGender
//                VC.age = age
//            }
//        }
//
//
//        if segue.identifier == "backToFemalePartner" {
////            dismiss(animated: true, completion: nil)
//
//            let VC = segue.destination as! FemaleSearchPartnerViewController
//            VC.firstNametextLable = firstNametextLable
//            VC.IDs = Ids
//
//        }
//    }
//
//}
