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
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ForFemaleFirstNameTextLabel.text = stringHolder
        ForFemaleProfilePic.layer.cornerRadius = 75
        ForFemaleProfilePic.layer.masksToBounds = true
        ForFemaleProfilePic.image = femaleProfilePicImage

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
