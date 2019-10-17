////
////  FemaleChatLogTableViewCell.swift
////  HateDatingApp
////
////  Created by Prithviraj Murthy on 14/01/19.
////  Copyright © 2019 Prithviraj Murthy. All rights reserved.
////
//
//import UIKit
//import SVProgressHUD
//import Firebase
//
//class FemaleChatLogTableViewCell: UITableViewCell {
//
//    var leadingConstraint : NSLayoutConstraint!
//    var trailingConstraint : NSLayoutConstraint!
//    var bubbleleadingConstraint : NSLayoutConstraint!
//    var bubbletrailingConstraint : NSLayoutConstraint!
//    var width_Anchor: NSLayoutConstraint!
//    var height_Anchor : NSLayoutConstraint!
//    
//    let messageLabel = UILabel()
//    let bubbleView = UIView()
//    
//    
//    let messageImageView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 12
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        
//        return imageView
//    }()
//    let imageURL = "https:"
//    var messages = message()
//    
//    var FemaleChatMessage : FemaleChatMessage! {
//        didSet {
//            
//            if FemaleChatMessage.isIncoming {
//                bubbleView.backgroundColor = .white
//
//            }
////            bubbleView.backgroundColor = FemaleChatMessage.isIncoming ? .white : UIColor(red: 0, green: 0.5765, blue: 0.0863, alpha: 1.0)
//            messageLabel.textColor = FemaleChatMessage.isIncoming ? .black : .white
//            
//            
//            
//            if FemaleChatMessage.text.contains(imageURL){
//                self.width_Anchor.isActive = true
//                self.height_Anchor.isActive = true
//                guard let url = URL(string: FemaleChatMessage.text) else {
//                    return
//                }
//                
//                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                    SVProgressHUD.show()
//                    if error != nil {
//                        //                        print("Failed while fetching images : \(error?.localizedDescription)")
//                        return
//                    } else {
//                        //Posting the downloaded image from firbase database onto the imageView.
//                        DispatchQueue.main.async {
//                            SVProgressHUD.dismiss()
//                            
//                            self.messageImageView.image = UIImage(data: data!)
//                            
//                        }
//                    }
//                    
//                }).resume()
//                
//            }else{
//                messageLabel.text = FemaleChatMessage.text
//
//            }
//            
//            if FemaleChatMessage.isIncoming == true {
//                leadingConstraint.isActive = true
//                trailingConstraint.isActive = false
//            }else{
//                leadingConstraint.isActive = false
//                trailingConstraint.isActive = true
//            }
//            
//        }
//    }
//    
//    
//    
//    //    var isIncoming : Bool! {
//    //        didSet {
//    //            bubbleView.backgroundColor = isIncoming ? .white : .darkGray
//    //            messageLabel.textColor = isIncoming ? .black : .white
//    //        }
//    //    }
//    //    var isIncoming : Bool!
//    //    var outGoing : Bool!
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        
//        //        print("ISINCOMING IS \(isIncoming)")
//        backgroundColor = .clear
//        
////        bubbleView.backgroundColor = .yellow
//        bubbleView.translatesAutoresizingMaskIntoConstraints = false
//        bubbleView.layer.cornerRadius = 12
//       
//        addSubview(bubbleView)
//        addSubview(messageLabel)
////        addSubview(messageImageView)
//        
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        messageLabel.numberOfLines = 0
//        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
//        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
//        messageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        
//        let DB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(Auth.auth().currentUser!.uid)
//        DB.observe(.value) { (snap) in
//            if let snapValue = snap.value as? NSDictionary{
//                let firstName = snapValue["First Name "] as! String
//                let maleName = snapValue["Male name "] as! String
//                let maleId = snapValue["Male Id "] as! String
//                
//                let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(Auth.auth().currentUser!.uid).child(firstName).child(maleId).child(maleName).child("Messages")
//                messageDB.observeSingleEvent(of: .childAdded, with: { (snapshot) in
//                    
//                    let snapshotValue = snapshot.value as! NSDictionary
//                    if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
//
//                        let width = snapshotValue["Text Widht "] as! CGFloat
//                        if width < 60 {
//                            
//                            self.messageLabel.widthAnchor.constraint(equalToConstant: (width) + 20).isActive = true
//                            print("WIDTH IS \(width)")
//                            
//                        }else{
//                            self.messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
//                            
//                        }
//                        
//                    }
//                    
//                })
//                
//            }
//            
//        }
//
//        
//        
//        
//        bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
//        bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16).isActive = true
//        bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16).isActive = true
//        bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16).isActive = true
//        //        print("IS INCOMING \(isIncoming)")
//        
//        
//        width_Anchor =  bubbleView.widthAnchor.constraint(equalToConstant: 250)
//        height_Anchor = bubbleView.heightAnchor.constraint(equalToConstant: 300)
//        
////        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
////        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
////        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
////        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
//        
//        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
//        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -32)
//        
//    }
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }
//}
