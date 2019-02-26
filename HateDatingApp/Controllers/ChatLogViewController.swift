//
//  ChatLogViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 19/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController: UICollectionViewController, UITextFieldDelegate {
    var firstNametextLable : String = ""
    var femaleName : String = ""

    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Chat log"
//        collectionView?.backgroundView = UIColor()
        setupInputComments()
        print("The name of the logged in Male is \(firstNametextLable) & the female he is matched with is \(femaleName)")

    }

    func setupInputComments(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)

        containerView.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)

        sendButton.rightAnchor.constraint(lessThanOrEqualTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(lessThanOrEqualTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor).isActive = true

        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter Message"
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(inputTextField)

        inputTextField.leftAnchor.constraint(lessThanOrEqualTo: containerView.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(lessThanOrEqualTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(lessThanOrEqualTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor).isActive = true

        let separtorLineView = UIView()
        separtorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        separtorLineView.translatesAutoresizingMaskIntoConstraints = false
        separtorLineView.addSubview(separtorLineView)

        separtorLineView.leftAnchor.constraint(lessThanOrEqualTo: containerView.leftAnchor).isActive = true
        separtorLineView.topAnchor.constraint(lessThanOrEqualTo: containerView.topAnchor).isActive = true
        separtorLineView.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor).isActive = true
        separtorLineView.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor).isActive = true

    }

    
    @objc func handleSend(){
        let ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(firstNametextLable).child(femaleName).child("Messages")
        let values = ["Text" : inputTextField.text!]
        ref.updateChildValues(values)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
