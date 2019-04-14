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
    let changeTypes = ["Change email","Change Password"]
    var userID = Auth.auth().currentUser?.uid
    var gender : String!
    @IBOutlet var ChangeTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var backToMaleOrFemale: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBar.topItem!.title = "Settings"
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
//        ChangeTableView.addGestureRecognizer(tapGesture)
        ChangeTableView.separatorStyle = .none
        ChangeTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        ChangeTableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        ChangeTableView.delegate = self
        ChangeTableView.dataSource = self
        ChangeTableView.clipsToBounds = true
        configureTableView()
        
    }
    
    
    func configureTableView() {
        ChangeTableView.rowHeight = UITableViewAutomaticDimension
        ChangeTableView.estimatedRowHeight = 120.0
    }
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.textLabel?.text = changeTypes[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "goToChangeEmail", sender: self)

        }else{
            performSegue(withIdentifier: "goToChangePassword", sender: self)

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    @IBAction func backToMaleOrFemale(_ sender: Any) {
        
        
        if gender == "Male"{
            performSegue(withIdentifier: "backToMale", sender: self)
        }else{
            performSegue(withIdentifier: "backToFemale", sender: self)
        }
        
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
        }else {
            let destinationVC = segue.destination as! FemaleSearchPartnerViewController
            destinationVC.firstNametextLable = firstNametextLable
        }

    }
    

}
