////
////  ChatViewController.swift
////  HateDatingApp
////
////  Created by Prithviraj Murthy on 20/12/18.
////  Copyright © 2018 Prithviraj Murthy. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseDatabase
//
//class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
////class ChatViewController: UITableViewController, UITextFieldDelegate {
//
//    var messageArray : [message] = [message]()
//
//    var sentMessages = [String]()
//
//
//
//    private var cellId = "customMessageCell"
//    var firstNametextLable : String = ""
//    var femaleName : String = ""
//    let userID = Auth.auth().currentUser?.uid
//
//    @IBOutlet weak var sendButton: UIButtonX!
//    @IBOutlet weak var inputTextField: UITextFieldX!
//    @IBOutlet weak var messageTableView: UITableView!
//    //    lazy var inputTextField : UITextField = {
////        let textField = UITextField()
////        textField.placeholder = "Enter Message"
////        textField.translatesAutoresizingMaskIntoConstraints = false
////        textField.delegate = self
////        return textField
////    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.title = femaleName
//        //    collectionView?.backgroundView = UIColor.init()
//        //setupInputComments()
//          let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
//        messageTableView.addGestureRecognizer(tapGesture)
//
////        tableView.register(ChatLogTableViewCell.self, forCellReuseIdentifier: cellId)
//        print("The name of the logged in Male is \(firstNametextLable) & the female he is matched with is \(femaleName)")
//        messageTableView.delegate = self
//        messageTableView.dataSource = self
//        messageTableView.clipsToBounds = true
//        configureTableView()
////        retreiveSentMessages()
//        retrieveMessages()
//
//    }
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messageArray.count
//    }
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatLogTableViewCell
//
////        cell.textLabel?.text = messageArray[indexPath.row].sentMessage
//        cell.messageLabel.text = messageArray[indexPath.row].messageBody
//
//
//
//        return cell
//    }
//
//    //TODO: Declare configureTableView here:
//
//    func configureTableView() {
//        messageTableView.rowHeight = UITableViewAutomaticDimension
//        messageTableView.estimatedRowHeight = 120.0
//
//
//    }
//    @objc func tableViewTapped() {
//        inputTextField.endEditing(true)
//    }
//
//    @IBAction func sendButton(_ sender: Any) {
//        handleSend()
//        inputTextField.endEditing(true)
//        sendButton.isEnabled = false
//    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        var height : CGFloat = 80
////
////        return CGSize(width: view.frame.width, height: 80)
////    }
//
//
//
//     func handleSend(){
//
//        var messages = message()
//
//        let ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(firstNametextLable).child(femaleName).child("Messages")
//      //  let values = ["Latest Message " : inputTextField.text!]
//        let timeStamp = Date().timeIntervalSinceNow
////        messages.timeStamp = timeStamp
////        let toId = messages.receiverID
////        let messageDictionary = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp ": timeStamp,
////                                 "MessageBody ": inputTextField.text!] as [String : Any]
//
////        messages.sentMessage = inputTextField.text!
//        let messageDictionary = ["Sender ID ": userID,"Time Stamp ": timeStamp,
//                                 "MessageBody ": inputTextField.text!] as [String : Any]
//        ref.childByAutoId().setValue(messageDictionary) { (error, ref) in
//            if error != nil {
//                print("Error while saving the message sent")
//            }else{
//                print("Message sent successfully")
//            }
//            self.inputTextField.isEnabled = true
//            self.sendButton.isEnabled = true
//            self.inputTextField.text = ""
//
//        }
//
//    }
//
//    func retreiveSentMessages() {
//
//        let messageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Male").child(firstNametextLable).child(femaleName).child("Messages")
//
////        messageDB.observeSingleEvent(of: .value) { (snap) in
//
//
//            messageDB.observe(.childAdded) { (snapshot) in
//                print(snapshot)
//                let snapshotValue = snapshot.value as? Dictionary<String,String>
//                let text = snapshotValue!["MessageBody "]!
//                //let sender = snapshotValue!["Sender "]!
//
//                let messages = message()
//                messages.sentMessage = text
//              //  messages.sender = sender
//
//                self.messageArray.append(messages)
//
//
//                self.configureTableView()
//                self.messageTableView.reloadData()
//
//            }
//
////        }
//
//    }
//
//    func retrieveMessages() {
//
////        let toId = messages.receiverID
//
//        let messageDB = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Match").child("Female").child(femaleName).child(firstNametextLable).child("Messages")
//
//        messageDB.observeSingleEvent(of: .value) { (snap) in
//
//
//        messageDB.observe(.childAdded) { (snapshot) in
//            print(snapshot)
//            let snapshotValue = snapshot.value as? Dictionary<String,String>
//            let text = snapshotValue!["MessageBody "]!
//            let sender = snapshotValue!["Sender "]!
//
//            let messages = message()
//            messages.messageBody = text
//            messages.sender = sender
//
//            self.messageArray.append(messages)
//
//
//            self.configureTableView()
//            self.messageTableView.reloadData()
//
//            }
//
//        }
//
//    }
//
//    private func estimateFrameForText(text: String) -> CGRect {
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil )
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.5) {
//           // self.heightConstraint.constant = 308
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        handleSend()
//        return true
//    }
//
//}
