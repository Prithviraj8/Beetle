//
//  UserTableViewCell.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 05/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageViewX!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var user = User()
    
    var username : String = ""
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        user.firstNametextLable = username
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
      //  avatarImageView.isUserInteractionEnabled = true
//        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        print("The username is \(username)")

    }

    func generateUserCell(username: String, indexPath: IndexPath) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @objc func avatarTap() {
//        print("The avatar is \(indexPath)")
        print("The username is \(username)")
    }
    
}
