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
    var stringHolder: String = ""
    var MaleProfilPicImage : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNametextLable.text = stringHolder
        ProfilePic.layer.cornerRadius = 75
        ProfilePic.layer.masksToBounds = true
        ProfilePic.image = MaleProfilPicImage
    }

    
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


















