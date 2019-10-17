//
//  ChatInputContainerView.swift
//  gameofchats
//
//  Created by Brian Voong on 8/10/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

//class ChatInputContainerView: UIView, UITextFieldDelegate {
//    
//    weak var chatLogController: ChatLogController? {
//        didSet {
//            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
//            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
//        }
//    }
//    let bottomView : UIView={
//        let view = UIView()
//        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.masksToBounds = true
//        view.backgroundColor = UIColor.lightGray
//        view.layer.borderColor = UIColor.gray.cgColor
//        view.layer.borderWidth = 2
//        return view
//    }()
//
//    lazy var inputTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter message..."
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        return textField
//    }()
//    
//    let uploadImageView: UIImageView = {
//        let uploadImageView = UIImageView()
//        uploadImageView.isUserInteractionEnabled = true
//        uploadImageView.image = UIImage(named: "images")
//        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
//        return uploadImageView
//    }()
//    
//    let sendButton = UIButton(type: .system)
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        backgroundColor = .white
//        addSubview(bottomView)
//        bottomView.addSubview(uploadImageView)
//        //x,y,w,h
//        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        uploadImageView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
//        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        
//        
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.setImage(UIImage(named: "transfer")?.withRenderingMode(.alwaysOriginal), for: .normal)
//
//        //what is handleSend?
//        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        bottomView.leadingAnchor.constraint(equalTo:leadingAnchor).isActive = true
//        bottomView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        bottomView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        
//        bottomView.addSubview(sendButton)
//        //x,y,w,h
////        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
////        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
////        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
////        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//        
//        sendButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
//        bottomView.addSubview(self.inputTextField)
//        //x,y,w,h
//        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
//        self.inputTextField.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
//        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        self.inputTextField.heightAnchor.constraint(equalTo: bottomView.heightAnchor).isActive = true
//        
//        
//
////        let separatorLineView = UIView()
////        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220,alpha: 1)
////        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
////        addSubview(separatorLineView)
////        //x,y,w,h
////        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
////        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
////        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
////        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//    
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        chatLogController?.handleSend()
//        return true
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
