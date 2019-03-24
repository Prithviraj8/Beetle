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
    var femaleId : String = ""
    var femaleName : String = ""
    let userID = Auth.auth().currentUser?.uid
    var messages = message()
    var ref : DatabaseReference!
    var NAMES : [names] = [names]()
    var femaleNames = [String]()
    var age : Int!
    var gender : String = ""
    
    
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

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return femaleNames.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//         Configure the cell...
    
        
        let name = femaleNames[indexPath.row]
        print("PRO IS \(profilePicURL)")

        let profilePic = profilePicURL[indexPath.row]
        print("PRO IS \(profilePic)")

        let id = IDs[indexPath.row]

        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(id)
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

            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(firstNametextLable).child(id).child(name).child("Messages")
                ref.observe(.childAdded) { (snapshot) in
                    
                    let snapshotValue = snapshot.value as! NSDictionary
                    
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
                let VC = segue.destination as! ChatLogTableViewController
                let femaleName = femaleNames[indexPath.row]
                let Id = IDs[indexPath.row]
                let profilePic = profilePicURL[indexPath.row]
                print("THE FEMALE NAME SELECTED IS \(femaleName)")
                VC.firstNametextLable = firstNametextLable
                VC.femaleName = femaleName
                VC.femaleId = Id
                VC.femaleNames = femaleNames
                VC.IDs = IDs
                VC.profilePicURL = profilePicURL
                VC.profilePic = profilePic
                VC.age = age
                VC.gender = "Male"
            }
        }
        
        if segue.identifier == "goBackToMaleSearch" {
            let VC = segue.destination as! SearchPartnerViewController
            VC.firstNametextLable = firstNametextLable
            VC.IDs = IDs
        }
        
    }
    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
     Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */
//    func loadUsers(filter : String) {
//        SVProgressHUD.show()
//
//
//    }
  


//extension UserTableViewController : UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //let request : NSFetchRequest
//    }
//}
}
