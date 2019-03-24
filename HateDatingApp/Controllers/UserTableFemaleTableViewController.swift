//
//  UserTableFemaleTableViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 24/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class UserTableFemaleTableViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    let searchController = UISearchController(searchResultsController: nil)
    var firstNametextLable : String = ""
    var maleName : String = ""
    var maleId : String = ""
    let userID = Auth.auth().currentUser?.uid
    var NAMES : [names] = [names]()
    var ref : DatabaseReference!
    var maleNames = [String]()
    var Ids = [String]()
    var profilePicURL = [String]()
    var gender : String = ""
    var age : Int!
    
    @IBOutlet weak var matchesTableView: UITableView!
    
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
    }

    // MARK: - Table view data source
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        return maleNames.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        
        //         Configure the cell...
        let name = maleNames[indexPath.row]
        let profilePic = profilePicURL[indexPath.row]
        let id = Ids[indexPath.row]
        //        print("PICS AREE \(profilePicURL)")
        
        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(id)
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
            
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(firstNametextLable).child(id).child(name).child("Messages")
            ref.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! NSDictionary
                
                if let ReceivedTimeStamp = snapshotValue["Time Stamp Received "] as? Double {
                    
                    //                            print("LATEST TIME STAMP OF THE MESSAGE RECEIVED IS \(String(describing: ReceivedTimeStamp))")
                    
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
                let VC = segue.destination as! ChatViewFemaleViewController
                let male = maleNames[indexPath.row]
                let id = Ids[indexPath.row]
                let profilePic = profilePicURL[indexPath.row]
                VC.firstNametextLable = firstNametextLable
                VC.maleName = male
                VC.maleId = id
                VC.maleNames = maleNames
                VC.Ids = Ids
                VC.profilePicURL = profilePicURL
                VC.profilePic = profilePic
                VC.gender = "Female"
                VC.age = age
            }
        }
        
        
        if segue.identifier == "backToFemalePartner" {
            let VC = segue.destination as! FemaleSearchPartnerViewController
            VC.firstNametextLable = firstNametextLable
            VC.IDs = Ids

        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
