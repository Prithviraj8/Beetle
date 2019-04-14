//
//  PotentialMatchesTableViewCell.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 13/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class PotentialMatchesTableViewCell: UITableViewCell {

    let ProfileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.layer.borderColor = UIColor.flatYellowColorDark().cgColor
        label.layer.borderWidth = 3
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.flatYellow()
        label.textAlignment = .center
        return label
    }()
    
    var match : Matches! {
        didSet {
            
            nameLabel.text = match.name
            
            guard let url = URL(string: match.profilePic) else {
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                //                    SVProgressHUD.show()
                if error != nil {
                    //                        print("Failed while fetching images : \(error?.localizedDescription)")
                    return
                } else {
                    //Posting the downloaded image from firbase database onto the imageView.
                    DispatchQueue.main.async {
                        //                            SVProgressHUD.dismiss()
                        print("Collected IMAGE for potential partners")
                        self.ProfileImageView.image = UIImage(data: data!)
                        
                    }
                }
                
            }).resume()
            

        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // Configure the view for the selected state
     
        
        addSubview(ProfileImageView)
        addSubview(nameLabel)
        
        ProfileImageView.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
        ProfileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        ProfileImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        ProfileImageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        ProfileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        ProfileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: ProfileImageView.bottomAnchor,constant: 4).isActive = true
//        nameLabel.bottomAnchor.constraint(equalTo: ProfileImageView.topAnchor,constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 32).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -32).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
