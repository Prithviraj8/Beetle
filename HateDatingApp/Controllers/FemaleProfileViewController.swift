//
//  FemaleProfileViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 16/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit

class FemaleProfileViewController: UIViewController {

    @IBOutlet weak var ForFemaleProfilePic: UIImageView!
    @IBOutlet weak var ForFemaleFirstNameTextLabel: UILabel!
    
    var stringHolder: String = ""
    var femaleProfilePicImage : UIImage!
    var count : Int = 0
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         ForFemaleFirstNameTextLabel.text = stringHolder
        ForFemaleProfilePic.translatesAutoresizingMaskIntoConstraints = false
        ForFemaleProfilePic.layer.cornerRadius = 10
        ForFemaleProfilePic.layer.masksToBounds = true
        ForFemaleProfilePic.image = femaleProfilePicImage

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchPartner"{
            let destinationVC = segue.destination as! SearchPartnerViewController
            destinationVC.firstNametextLable = stringHolder
            destinationVC.userID = userID
            destinationVC.CurrentUserGender = "Female"
            destinationVC.gender = "Male"

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
