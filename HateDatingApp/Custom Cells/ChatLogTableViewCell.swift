//
//  ChatLogTableViewCell.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 31/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit

//class ChatLogTableViewCell: UITableViewCell {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    let textView : UITextView = {
//
//        let tv = UITextView()
//        //tv.text = "SAMPLE TEXT FOR NOW "
//        tv.font = UIFont.systemFont(ofSize: 16)
//        tv.backgroundColor = UIColor.clear
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.textColor = .white
//        return tv
//
//    }()
//
//    let bubbleView : UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.blue
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//
//        addSubview(bubbleView)
//        addSubview(textView)
//
//                backgroundColor = .clear
//
////                bubbleView.backgroundColor = .yellow
//                bubbleView.translatesAutoresizingMaskIntoConstraints = false
//                bubbleView.layer.cornerRadius = 12
//                addSubview(bubbleView)
//
//                //        messageLabel.backgroundColor = .green
//                //        messageLabel.text = "MESSAGES hey how are you im okay can u kill me now hey there what hc doing??? avenger"
//                textView.translatesAutoresizingMaskIntoConstraints = false
//
//                textView.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
//                textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
//                textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
//                textView.widthAnchor.constraint(equalToConstant: 250).isActive = true
//
//
//                bubbleView.topAnchor.constraint(equalTo: textView.topAnchor, constant: -16).isActive = true
//                bubbleView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -16).isActive = true
//                bubbleView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16).isActive = true
//                bubbleView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 16).isActive = true
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}

//
//  ChatLogTableViewCell.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 31/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit


class ChatLogTableViewCell: UITableViewCell {


    var leadingConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!
    var bubbleleadingConstraint : NSLayoutConstraint!
    var bubbletrailingConstraint : NSLayoutConstraint!
    
    let messageLabel = UILabel()
    let bubbleView = UIView()

    var chatMessage : ChatMessage! {
        didSet {
            bubbleView.backgroundColor = chatMessage.isIncoming ? .white : .darkGray
            messageLabel.textColor = chatMessage.isIncoming ? .black : .white
            messageLabel.text = chatMessage.text

            if chatMessage.isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }else{
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }

        }
    }
    
    var FemaleChatMessage : FemaleChatMessage! {
        didSet {
            bubbleView.backgroundColor = FemaleChatMessage.isIncoming ? .white : .darkGray
            messageLabel.textColor = FemaleChatMessage.isIncoming ? .black : .white
            messageLabel.text = FemaleChatMessage.text
            
            if FemaleChatMessage.isIncoming == true {
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
        
//        print("ISINCOMING IS \(isIncoming)")
        backgroundColor = .clear

        bubbleView.backgroundColor = .yellow
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 12
        addSubview(bubbleView)

        addSubview(messageLabel)
        //        messageLabel.backgroundColor = .green
        //        messageLabel.text = "MESSAGES hey how are you im okay can u kill me now hey there what hc doing??? avenger"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0

       
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant : 32).isActive = true
//        if isIncoming == true {
//            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
//            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -32).isActive = false
//
//        }else {
//            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant : -32).isActive = true
//            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = false
//
//        }
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true


        bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16).isActive = true
//        bubbleleadingConstraint =  bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16)
        bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16).isActive = true
//        bubbletrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16).isActive = true
//        print("IS INCOMING \(isIncoming)")

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
