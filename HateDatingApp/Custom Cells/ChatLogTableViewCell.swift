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
//            messageLabel.text = chatMessage.text

            if chatMessage.text.localizedStandardContains(imageURL) == true{
                print("chatMessage doest contain \(chatMessage.text.localizedStandardContains(imageURL))")

                bubbleView.backgroundColor = UIColor.clear
                imageConstraints.forEach({ (constraint) in
                    constraint.isActive = true
                })
                
                guard let url = URL(string: chatMessage.text) else {
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
                            print("RECIEVED IMAGE")
                            self.messageImageView.image = UIImage(data: data!)
                            
                        }
                    }
                    
                }).resume()
                
            }else{

                messageLabel.text = chatMessage.text
//                bubbleViewWidhtAnchor.isActive = true
             
            }

            if chatMessage.isIncoming == true {
                bubbleView.backgroundColor = .white

//                imageleadingConstraint.isActive = true
//                ImagetrailingConstraint.isActive = false
                
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
//                imageleadingConstraint.isActive = false
//                ImagetrailingConstraint.isActive = true
                
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
        
        bubbleViewWidhtAnchor = bubbleView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor ,constant: 8)
//        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
//      messageConstraints = [
//        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32),
//        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
//        messageLabel.widthAnchor.constraint(equalToConstant: 200),
//
//        bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
//        bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
//        bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
//        bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
//        ]
        
        //Setting up Image View

        width_Anchor =  bubbleView.widthAnchor.constraint(equalToConstant: 250)
        height_Anchor = bubbleView.heightAnchor.constraint(equalToConstant: 250)
      
     imageConstraints = [
        messageImageView.topAnchor.constraint(equalTo: topAnchor),
        messageImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor),
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor),
        
//        bubbleView.topAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -16),
//        bubbleView.leadingAnchor.constraint(equalTo: messageImageView.leadingAnchor, constant: -16),
//        bubbleView.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 16),
//        bubbleView.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: 16)
        
        ]
        
        imageleadingConstraint = messageImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        ImagetrailingConstraint = messageImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//                leadingConstraint.isActive = false
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -32)
        
        //        trailingConstraint.isActive = true
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
