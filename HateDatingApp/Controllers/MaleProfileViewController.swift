//
//  YourProfileViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 28/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase


class MaleProfileViewController: UIViewController {

    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var firstNametextLable: UILabel!
    
    var userID = ""
    var stringHolder: String = ""
    var MaleProfilPicImage : UIImage!
    var count : Int = 0
    var age : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNametextLable.text = stringHolder
        ProfilePic.layer.cornerRadius = 75
        ProfilePic.layer.masksToBounds = true
        ProfilePic.image = MaleProfilPicImage
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchPartner" {
            let destinationVC = segue.destination as! SearchPartnerViewController
            
            destinationVC.firstNametextLable = stringHolder
            destinationVC.userID = userID
            destinationVC.age = age
        }
    }
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


















