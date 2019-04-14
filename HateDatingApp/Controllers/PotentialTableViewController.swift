//
//  PotentialTableViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 13/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

struct Matches {
    var name : String!
    var profilePic : String!
}

class PotentialTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var PotentialMatchesTV: UITableView!
    
    var matches = [Matches]()
    var matchedUsers : [potentialMatchedUsers] = [potentialMatchedUsers]()
    var users = potentialMatchedUsers()
    var gender : String!
    var firstNametextLable : String!
    var currentUserGender : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        PotentialMatchesTV.separatorStyle = .none
        PotentialMatchesTV.backgroundColor = .white
        PotentialMatchesTV.delegate = self
        PotentialMatchesTV.register(PotentialMatchesTableViewCell.self, forCellReuseIdentifier: "Match")
        PotentialMatchesTV.delegate = self
        PotentialMatchesTV.dataSource = self
        PotentialMatchesTV.clipsToBounds = true
        configureTableView()
        getPotentialUsers()
        print("ROW COUNT IS \(matchedUsers.count)")
        
        if matches.count > 0{
            let indexPath = NSIndexPath(item: matches.count - 1, section: 0)
            self.PotentialMatchesTV.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }

    }
    func configureTableView() {
        PotentialMatchesTV.rowHeight = UITableViewAutomaticDimension
        PotentialMatchesTV.estimatedRowHeight = 120.0
    }
    
    func getPotentialUsers() {
        let currentRef = Database.database().reference().child("users").child(currentUserGender).child(Auth.auth().currentUser!.uid)
        
        
        let ref = Database.database().reference().child("users").child(gender)
        ref.observe(.childAdded) { (snapshot) in
                let ref2 = ref.child(snapshot.key)

            ref2.observe(.value, with: { (snap) in
                let snapValue = snap.value as! NSDictionary
//                print("Potential Matched users are \(snapshot)")

                
                if let description = snapValue["Description  "] as? String{
                    let name = snapValue["Name "] as? String
                    let id = snapValue["UserId "] as? String
                    let profilePicURL = snapValue["Profile Pic "] as? String
                    self.users.name = name!
                    self.users.id = id!
                    self.users.profilePicURL = profilePicURL!
                    self.matchedUsers.append(self.users)
                    print("Potential Matched users are \(self.matchedUsers.count)")
                    let match = Matches(name: name, profilePic: profilePicURL)
                    self.matches.append(match)
                    print("MATCHES C IS \(self.matches.count)")
                }
                self.configureTableView()
                self.PotentialMatchesTV.reloadData()
            })
//            self.configureTableView()
            self.PotentialMatchesTV.reloadData()
            
        }
    }
    
    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return matches.count
        
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Match", for: indexPath) as! PotentialMatchesTableViewCell

//         Configure the cell...

        let match = matches[indexPath.row]
        cell.match = match
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        return cell
    }
 
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
