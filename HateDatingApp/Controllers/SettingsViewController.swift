//
//  SettingsViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 27/02/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
    

    private var cellId = "Change"
    var firstNametextLable : String = ""
    let changeTypes = ["Change email","Change Password","Privacy and Terms"]
    var userID = Auth.auth().currentUser?.uid
    var gender : String!
    @IBOutlet var ChangeTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backToMaleOrFemale: UIBarButtonItem!
    @IBOutlet weak var TopViewPivacy: UIView!
    @IBOutlet weak var PrivacyLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar?.topItem!.title = "Settings"
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
//        ChangeTableView.addGestureRecognizer(tapGesture)
        ChangeTableView?.separatorStyle = .none
        ChangeTableView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        ChangeTableView?.register(UserCell.self, forCellReuseIdentifier: cellId)
        ChangeTableView?.delegate = self
        ChangeTableView?.dataSource = self
        ChangeTableView?.clipsToBounds = true
        configureTableView()
        TopViewPivacy?.translatesAutoresizingMaskIntoConstraints = false
        TopViewPivacy?.layer.masksToBounds = true
        TopViewPivacy?.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
        PrivacyLabel?.translatesAutoresizingMaskIntoConstraints = false
        PrivacyLabel?.layer.masksToBounds = true
        
    }
    
    
    func configureTableView() {
        ChangeTableView?.rowHeight = UITableViewAutomaticDimension
        ChangeTableView?.estimatedRowHeight = 120.0
    }
    
   
    @IBAction func backButton(_ sender: Any) {

        if gender == "Male"{
            performSegue(withIdentifier: "backToMale", sender: self)
        }else{
            performSegue(withIdentifier: "backToFemale", sender: self)
        }
    }
    @IBAction func privacyPageBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changeTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let type = changeTypes[indexPath.row]
        
        cell.textLabel?.text = type
        if type == "Privacy and Terms" {
            cell.profileImageView.image = UIImage(named: "Privacy")
        }
        if type == "Change email" {
            cell.profileImageView.image = UIImage(named: "Change Email")
        }
        if type == "Change Password" {
            cell.profileImageView.image = UIImage(named: "Change password")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "goToChangeEmail", sender: self)

        }else if indexPath.row == 1{
            performSegue(withIdentifier: "goToChangePassword", sender: self)

        }else {
            performSegue(withIdentifier: "Privacy and Terms", sender: self)

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeEmail" {
            let destinationVC = segue.destination as! ChangeInfoViewController
            destinationVC.firstNametextLable = firstNametextLable

//            destinationVC.email.text = Auth.auth().currentUser?.email
            destinationVC.userID = userID!

        }else if segue.identifier == "goToChangePassword" {
            let destinationVC = segue.destination as! PasswordChangeViewController
            destinationVC.gender = gender
            destinationVC.firstNametextLable = firstNametextLable
            
        
        }else if segue.identifier == "backToMale"{
            let destinationVC = segue.destination as! SearchPartnerViewController
            destinationVC.firstNametextLable = firstNametextLable
            
        }else if segue.identifier == "backToFemale"{
            let destinationVC = segue.destination as! FemaleSearchPartnerViewController
            destinationVC.firstNametextLable = firstNametextLable
        }

    }
    

}
