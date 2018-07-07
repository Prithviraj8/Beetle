//
//  YourProfileViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 28/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase


class YourProfileViewController: UIViewController {

    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var ForFemaleProfilePic: UIImageView!
    
    @IBOutlet weak var firstNametextLable: UILabel!
    var stringHolder: String = ""
        
    @IBOutlet weak var ForFemaleFirstNameTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNametextLable.text = stringHolder
        firstNametextLable.text = stringHolder
        
        ProfilePic.image = ProfilePic.image
        ForFemaleProfilePic.image = ForFemaleProfilePic.image
    }

    
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


















