//
//  ChatViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 20/12/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import UserNotifications

struct ChatMessage {
    let text : String
    let isIncoming : Bool
//    let outGoing : Bool
}


class ChatLogTableViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var messageArray : [message] = [message]()
    var chatMessages = [ChatMessage]()
    
    var sentMessages = [String]()
    
    
    
    private var cellId = "customMessageCell"
    var firstNametextLable : String = ""
    var femaleId : String = ""
    let userID = Auth.auth().currentUser?.uid
    var femaleName : String = ""
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = femaleName
//        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        sendButton.isEnabled = false
        
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        messageTableView.register(ChatLogTableViewCell.self, forCellReuseIdentifier: cellId)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.clipsToBounds = true
        configureTableView()
        
        setupKeyBoardObservers()

        retreiveMessage()
        
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
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
    
    
    func retreiveMessage() {
    
        let messageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName).child("Messages")
        
        
        messageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! NSDictionary
//                let ReceivedMessage = snapshotValue["ReceivedMessage "]
                let timeStamp = snapshotValue["Time Stamp "]
                
                
                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
                    
                    let message2 = ChatMessage(text: ReceivedMessage as! String, isIncoming: true)
                    self.chatMessages.append(message2)
                    let messages = message()
                    messages.messageBody = ReceivedMessage as! String
                    self.messageArray.append(messages)
                    
                }
                if let SentMessage = snapshotValue["SentMessage "] {
                    let message1 = ChatMessage(text: SentMessage as! String, isIncoming: false)
                    self.chatMessages.append(message1)
                    let messages = message()
                    messages.messageBody = SentMessage as! String
                    self.messageArray.append(messages)
                }
                
                
        
                self.configureTableView()
                self.messageTableView.reloadData()
                
            }
            
        }
        
        
    }
    
   
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messageArray.count
        return chatMessages.count
    }
    let chat = ChatLogTableViewCell()
    var messages = message()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatLogTableViewCell
        let Message  = chatMessages[indexPath.row]
        cell.chatMessage = Message
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
        sendButton.isEnabled = true
        handleSend()
        inputTextField.endEditing(true)
        sendButton.isEnabled = false
    }
    
    
    
     func handleSend(){
        
        var messages = message()
        
        let ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(femaleId).child(femaleName).child(userID!).child(firstNametextLable).child("Messages")
        let timeStamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeStamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        print("TIME IS \(time)")
                messages.timeStamp = timeStamp
                let toId = messages.receiverID
                let messageDictionary = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp ": timeStamp,
                                         "ReceivedMessage ": inputTextField.text!] as [String : Any]

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
      
        
        let ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName).child("Messages")
        
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
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil )
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
