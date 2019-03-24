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

class ChatLogTableViewCell: UITableViewCell {


    var leadingConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!
    var bubbleleadingConstraint : NSLayoutConstraint!
    var bubbletrailingConstraint : NSLayoutConstraint!
    var width_Anchor: NSLayoutConstraint!
    var height_Anchor : NSLayoutConstraint!
    
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
            bubbleView.backgroundColor = chatMessage.isIncoming ? .white : UIColor(red: 0, green: 0.5765, blue: 0.0863, alpha: 1.0)
            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
            
            if chatMessage.text.localizedStandardContains("https:"){
                print("chatMessage doest contain \(chatMessage.text.localizedStandardContains(imageURL))")
                self.width_Anchor.isActive = true
                self.height_Anchor.isActive = true
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
                    width_Anchor.isActive = false
                    height_Anchor.isActive = false
            }

            if chatMessage.isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }

        }
    }
    

    //    var isIncoming : Bool! {
    //        didSet {
    //            bubbleView.backgroundColor = isIncoming ? .white : .darkGray
    //            messageLabel.textColor = isIncoming ? .black : .white
    //        }
    //    }
//    var isIncoming : Bool!
//    var outGoing : Bool!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear

        bubbleView.backgroundColor = .yellow
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 12
        addSubview(bubbleView)
        addSubview(messageLabel)
        addSubview(messageImageView)
        

  

        //        messageLabel.backgroundColor = .green
        //        messageLabel.text = "MESSAGES hey how are you im okay can u kill me now hey there what hc doing??? avenger"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true

        
        bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
        bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16).isActive = true
        
        width_Anchor =  bubbleView.widthAnchor.constraint(equalToConstant: 250)
        height_Anchor = bubbleView.heightAnchor.constraint(equalToConstant: 300)
        
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
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
