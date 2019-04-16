//
//  ChatLogTableViewCell.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 31/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Foundation
import Firebase

class ChatLogTableViewCell: UITableViewCell {


    var leadingConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!
    var imageleadingConstraint : NSLayoutConstraint!
    var ImagetrailingConstraint : NSLayoutConstraint!
    var width_Anchor: NSLayoutConstraint!
    var height_Anchor : NSLayoutConstraint!
    var imageConstraints = [NSLayoutConstraint]()
    var messageConstraints = [NSLayoutConstraint]()
    var bubbleViewWidhtAnchor : NSLayoutConstraint!
    
    
    let messageLabel = UILabel()
    let bubbleView = UIView()
    let messageImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let imageURL = "https:"
    var messages = message()
   
    var chatMessage : ChatMessage! {
        didSet {
//            bubbleView.backgroundColor = chatMessage.isIncoming ? .white : .gray
            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
            messageLabel.text = chatMessage.text

            if chatMessage.isIncoming == true {
                bubbleView.backgroundColor = .white


                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{

                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }

        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 12
        addSubview(bubbleView)
        addSubview(messageLabel)
//        bubbleView.addSubview(messageImageView)
        

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        
        
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true


        bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
        bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16).isActive = true
        
        

    imageConstraints = [
        messageImageView.topAnchor.constraint(equalTo: topAnchor, constant : 32),
        messageImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
        messageImageView.widthAnchor.constraint(equalToConstant: 200),
        messageImageView.heightAnchor.constraint(equalToConstant: 250),
        
        bubbleView.topAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -16),
        bubbleView.leadingAnchor.constraint(equalTo: messageImageView.leadingAnchor, constant: -16),
        bubbleView.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 16),
        bubbleView.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: 16)
        ]
//
      messageConstraints = [
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32),
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
        messageLabel.widthAnchor.constraint(equalToConstant: 200),

        bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
        bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
        bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
        bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        

        
        imageleadingConstraint = messageImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        ImagetrailingConstraint = messageImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//
        
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -32)
//        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -32)

    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
        
    }

}
