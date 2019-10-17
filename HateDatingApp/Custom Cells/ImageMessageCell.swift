////
////  ImageMessageCell.swift
////  HateDatingApp
////
////  Created by Prithviraj Murthy on 24/04/19.
////  Copyright © 2019 Prithviraj Murthy. All rights reserved.
////
//
//import UIKit
//import Firebase
//class ImageMessageCell: UITableViewCell {
//    
//    
//    
//    var imageleadingConstraint : NSLayoutConstraint!
//    var ImagetrailingConstraint : NSLayoutConstraint!
//    
//    
//    
//    let messageImageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 12
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    let bubbleView = UIView()
//
//    
//    
//    var chatMessage : ChatMessage! {
//        didSet {
//            //            bubbleView.backgroundColor = chatMessage.isIncoming ? .white : .gray
//           
//            
//            if chatMessage.isIncoming == true {
//                bubbleView.backgroundColor = .white
//                
//                
//                imageleadingConstraint.isActive = true
//                ImagetrailingConstraint.isActive = false
//            }else{
//                
//                imageleadingConstraint.isActive = false
//                ImagetrailingConstraint.isActive = true
//            }
//            
//        }
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        addSubview(bubbleView)
//        addSubview(messageImageView)
//        
//        messageImageView.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
//        messageImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
//        messageImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        messageImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        
//        bubbleView.topAnchor.constraint(equalTo: messageImageView.topAnchor, constant: -4).isActive = true
//        bubbleView.leadingAnchor.constraint(equalTo: messageImageView.leadingAnchor, constant: -4).isActive = true
//        bubbleView.bottomAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 4).isActive = true
//        bubbleView.trailingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: 4).isActive = true
//        
//        
//        imageleadingConstraint = messageImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//        ImagetrailingConstraint = messageImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented\(aDecoder)")
//    }
//    
//   
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}
