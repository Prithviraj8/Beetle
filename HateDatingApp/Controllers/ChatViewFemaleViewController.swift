//
//  ChatViewFemaleViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 24/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

struct FemaleChatMessage {
    let text : String
    let isIncoming : Bool
}
class ChatViewFemaleViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    var messageArray : [message] = [message]()
    var chatMessages = [FemaleChatMessage]()
    
    var sentMessages = [String]()
    
    
    
    
    
    var firstNametextLable : String = ""
    var maleName : String = ""
    let userID = Auth.auth().currentUser?.uid
    var maleId : String = ""
    private var cellId = "customMessageCell"

    @IBOutlet weak var sendButton: UIButtonX!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextFieldX!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = maleName
        //navigationItem.title = maleName
        //    collectionView?.backgroundView = UIColor.init()
        //setupInputComments()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.register(FemaleChatLogTableViewCell.self, forCellReuseIdentifier: cellId)

//        print("The name of the logged in female is \(firstNametextLable) & the male she is matched with is \(maleName)")
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        messageTableView.delegate = self
        messageTableView.dataSource = self
        configureTableView()
//        retreiveMessages()
//        retrieveSentMessages()
        setupKeyBoardObservers()
        retreiveMessage()
//        sentMessage()

        
    }
    
    func setupKeyBoardObservers(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
    }
    
    @objc func handleKeyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
        
        
    }
    
    
    
    func retrieveSentMessages() {
        
//        let sentMessageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
                print("MUSER ID IS \(maleId)")

        let sentMessageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(maleId).child(maleName).child(userID!).child(firstNametextLable).child("Messages")
        
        sentMessageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            sentMessageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as? NSDictionary
                let text = snapshotValue!["Message "]!
//                let sender = snapshotValue!["Sender "]!
                
                let chatMessage = FemaleChatMessage(text: text as! String, isIncoming: false)
                self.chatMessages.append(chatMessage)
                print("SENT MESSAGES ARE \(text)")
                
                let messages = message()
                messages.messageBody = text as! String
//                messages.sender = sender as! String
                
                self.messageArray.append(messages)
                
                
                self.configureTableView()
                self.messageTableView.reloadData()
                
            }
            
        }
    }
    
    
    func retreiveMessage() {
        
        let messageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
        
        messageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! NSDictionary

                let timeStamp = snapshotValue["Time Stamp "]!
                
                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
                    let message2 = FemaleChatMessage(text: ReceivedMessage as! String, isIncoming: true)
                    self.chatMessages.append(message2)
                    print("Received MESSAGES ARE \(ReceivedMessage)")
                    let messages = message()
                    messages.messageBody = ReceivedMessage as! String
                    self.messageArray.append(messages)
                }
                if let SentMessage = snapshotValue["SentMessage "] {
                    
                    let message1 = FemaleChatMessage(text: SentMessage as! String, isIncoming: false)
                    self.chatMessages.append(message1)
//                    print("Sent MESSAGES ARE \(SentMessage)")
                    let messages = message()
                    messages.messageBody = SentMessage as! String
                    self.messageArray.append(messages)
                    
                }
           

                
           
                
                self.configureTableView()
                self.messageTableView.reloadData()
                
            }
            
        }
    }
    
    func sentMessage() {
        
        let messageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
        
        messageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as? NSDictionary
//                let ReceivedMessage = snapshotValue["ReceivedMessage "]
                let timeStamp = snapshotValue!["Time Stamp "]
                
                
      
                
                if let SentMessage = snapshotValue!["SentMessage "] {
                    
                    let message1 = FemaleChatMessage(text: SentMessage as! String, isIncoming: false)
                    self.chatMessages.append(message1)
                    print("Received MESSAGES ARE \(message1)")
                    let messages = message()
                    messages.messageBody = SentMessage as! String
                    self.messageArray.append(messages)
                    
                }else{
                    
                }

                
              
                
                self.configureTableView()
                self.messageTableView.reloadData()
                
            }
            
        }
    }
    
    func retreiveMessages() {
        
        let MessageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
//        print("MALE NAME IS\(maleName)")
        MessageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            MessageDB.observe(.childAdded) { (snapshot) in
                
                
                let snapshotValue = snapshot.value as? NSDictionary
                let text = snapshotValue!["MessageBody "]!
                let timeStamp = snapshotValue!["Time Stamp "]!
                
                
                print("RECEIVED MESSAGES ARE \(text)")
                let sentMessage = FemaleChatMessage(text: text as! String, isIncoming: true)
                self.chatMessages.append(sentMessage)
           
                
                let messages = message()
                messages.sentMessage = text as! String
                //  messages.sender = sender
                
                self.messageArray.append(messages)
                
                
                self.configureTableView()
                self.messageTableView.reloadData()
                
            }
            
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! FemaleChatLogTableViewCell
        let Message  = chatMessages[indexPath.row]

        cell.FemaleChatMessage = Message
        return cell
    
    }
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
        
        
    }
    @objc func tableViewTapped() {
        inputTextField.endEditing(true)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        if inputTextField.text == ""{
            sendButton.isEnabled = false
            sendButton.backgroundColor = .gray
        }
        handleSend()
        inputTextField.endEditing(true)
        sendButton.isEnabled = false
    }
    
    func handleSend(){
        var messages = message()

        let ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(maleId).child(maleName).child(userID!).child(firstNametextLable).child("Messages")

        let timeStamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeStamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        print("TIME IS \(time)")

        messages.timeStamp = timeStamp
        let toId = messages.receiverID
        let messageDictionary = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp Received ": timeStamp,"ReceivedMessage ": inputTextField.text!] as [String : Any]
        
        ref.childByAutoId().setValue(messageDictionary) { (error, ref) in
            if error != nil {
                print("Error while saving the message sent")
            }else{
                print("Message sent successfully")
            }
            self.inputTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.inputTextField.text = ""
            
        }
        
        let ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
        
        let messageDictionary2 = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp ": timeStamp,
                                  "SentMessage ": inputTextField.text!] as [String : Any]
        
        
        ref2.childByAutoId().setValue(messageDictionary2) { (error, ref) in
            if error != nil {
                print("Error while saving the message sent")
            }else{
                print("Message sent successfully")
            }
            self.inputTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.inputTextField.text = ""
            
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }

}
