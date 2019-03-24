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


class ChatLogTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var messageArray : [message] = [message]()
    var chatMessages = [ChatMessage]()
    
    var sentMessages = [String]()
    
    
    var profilePicURL = [String]()
    private var cellId = "customMessageCell"
    var firstNametextLable : String = ""
    var femaleId : String = ""
    var IDs = [String]()

    let userID = Auth.auth().currentUser?.uid
    var femaleName : String = ""
    var femaleNames = [String]()

    private let notificationPublisher = NotificationPublisher()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.topItem?.title = femaleName
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
        inputTextField.delegate = self
        configureTableView()
        
        setupKeyBoardObservers()
        inputTextField.keyboardAppearance = .default
        retreiveMessage()
        textViewDidChange(inputTextField)
        textViewDidBeginEditing(inputTextField)
        inputTextField.text = "Placeholder"
        inputTextField.textColor = UIColor.lightGray
        inputTextField.layer.cornerRadius = 10
        inputTextField.layer.borderColor = UIColor.darkGray.cgColor
        inputTextField.layer.borderWidth = 1
        


}
 
    
//    override func viewDidDisappear(_ animated: Bool) {
//        var ReceivedMessageTime = [Double]()
//
//        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName).child("Messages")
//
//        messageDB.observeSingleEvent(of: .value) { (snap) in
//
//
//            messageDB.observe(.childAdded) { (snapshot) in
//
//                let snapshotValue = snapshot.value as! NSDictionary
//
//                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
//
//                    print("WERRRRRRRR")
//
//                    let messageTimeStamp = snapshotValue["Time Stamp Received "] as! Double
//                    ReceivedMessageTime.append(messageTimeStamp)
//                    let currentTimeStamp = NSDate().timeIntervalSince1970
//                    let myTimeInterval = TimeInterval(currentTimeStamp)
//                    //                        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
//
//                    if ReceivedMessageTime.last! == currentTimeStamp {
//                        self.notificationPublisher.sendNotification(title: self.femaleName, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: 1, delayInterval: 1)
//                        self.notificationPublisher.name = self.femaleName
//                    }
//                }
//
//
//            }
//
//        }
////        messages.messagesRead = false
//    }
   

    
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
        
        let keyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }else{
            view.frame.origin.y = 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if keyboardShowing {
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    

    @IBAction func sendImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker = UIImage()
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker as? UIImage {
            uploadImageToFirebase(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(image: UIImage){
        let imageName = NSUUID().uuidString
        var storageRef: StorageReference!
        // let data = NSData()
        storageRef = Storage.storage().reference(forURL: "gs://hatedateapp-ea81a.appspot.com").child("images_sent").child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            //        if let uploadData = UIImagePNGRepresentation((femaleImageView?.image)!) {
            
            storageRef.putData(uploadData as Data, metadata: nil) { (metadata, error) in
                if error != nil {
//                    print("Error while uploading image : \(String(describing: error?.localizedDescription))")
                } else {
//                    print("Successfully saved images to database : \(String(describing: metadata))")
          
                    storageRef.downloadURL(completion: { (url, err) in
                        
                        if err != nil {
                            
//                            print("Error while downloadingURL : \(err?.localizedDescription)")
                            return
                        }
                        let downloadURL = url?.absoluteString
//                        let values = ["IMAGE SENT " : downloadURL!] as [String : AnyObject]
                       
                        let messages = message()
                        
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(self.femaleId).child(self.femaleName).child(self.userID!).child(self.firstNametextLable).child("Messages")
                        let timeStamp = NSDate().timeIntervalSince1970
                        let myTimeInterval = TimeInterval(timeStamp)
                        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                        
                        messages.timeStamp = timeStamp
                        let toId = messages.receiverID
                        let messageDictionary = ["ReceivedImage " : downloadURL!,"Image Width ": image.size.width, "Image Height ": image.size.height] as [String : AnyObject]

                        messages.imageHeight = image.size.height as? NSNumber
                        messages.imageWidth = image.size.width as? NSNumber
                        
                        ref.childByAutoId().setValue(messageDictionary) { (error, ref) in
                            if error != nil {
//                                print("Error while saving the message sent")
                            }else{
//                                print("Message sent successfully")
                            }
                            self.inputTextField.isSelectable = true
                            self.sendButton.isEnabled = true
                            self.inputTextField.text = ""
                            
                        }
                        
                        
                        let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(self.userID!).child(self.firstNametextLable).child(self.femaleId).child(self.femaleName).child("Messages")
                        
                        let messageDictionary2 = ["SentImage " : downloadURL!,"Image Width ": image.size.width, "Image Height ": image.size.height] as [String : AnyObject]
                        
                        ref2.childByAutoId().setValue(messageDictionary2) { (error, ref) in
                            if error != nil {
//                                print("Error while saving the message sent")
                            }else{
                                print("IMAGE sent successfully")
                            }
                            self.inputTextField.isSelectable = true
                            self.sendButton.isEnabled = true
                            self.inputTextField.text = ""
                            
                        }
                    })
                    
                }
            }
            //return
        }
    }
    
    func retreiveMessage() {
    
        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName).child("Messages")
        
        
        messageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! NSDictionary
        
                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
              
                
                    let message2 = ChatMessage(text: ReceivedMessage as! String, isIncoming: true)
                    self.chatMessages.append(message2)
                    let messages = message()
                    messages.messageBody = ReceivedMessage as! String
                    self.messageArray.append(messages)
                    print("RE MESS ID \(snapshot.key)")
                    messageDB.child(snapshot.key).updateChildValues(["Message Read ": "True"])
                    messageDB.child(snapshot.key).updateChildValues(["Message Notified ": "True"])

                }
//                if let ReceivedMessage = snapshotValue["ReceivedImage "] {
//
//                    let message2 = ChatMessage(text: ReceivedMessage as! String, isIncoming: true)
//                    self.chatMessages.append(message2)
//                    let messages = message()
//                    messages.messageBody = ReceivedMessage as! String
//                    self.messageArray.append(messages)
//
//                }
                if let SentMessage = snapshotValue["SentMessage "] {
                    
                    let message1 = ChatMessage(text: SentMessage as! String, isIncoming: false)
                    self.chatMessages.append(message1)
                    let messages = message()
                    messages.messageBody = SentMessage as! String
                    self.messageArray.append(messages)
                    print("RE MESS ID \(snapshot.key)")

                }
                
//                if let SentMessage = snapshotValue["SentImage "] {
//
//
//                    let message1 = ChatMessage(text: SentMessage as! String, isIncoming: false)
//                    self.chatMessages.append(message1)
//                    let messages = message()
//                    messages.messageBody = SentMessage as! String
//                    self.messageArray.append(messages)
//                }
        
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
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        messages.backButtonPressed = 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatLogTableViewCell
        let Message  = chatMessages[indexPath.row]
        cell.chatMessage = Message
        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
        if (inputTextField.text?.count)! > 0{
            handleSend()
        }
//        inputTextField.endEditing(true)
        
        inputTextField.text = ""

    }
    
    
    
     func handleSend(){
        
        var messages = message()
        
        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(femaleId).child(femaleName).child(userID!).child(firstNametextLable).child("Messages")
        let timeStamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeStamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        print("TIME IS \(time)")
                messages.timeStamp = timeStamp
                let toId = messages.receiverID
        let messageDictionary = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp Received ": timeStamp,"ReceivedMessage ": inputTextField.text!,"Message Read ": "False","Message Notified ": "False"] as [String : Any]


        ref.childByAutoId().setValue(messageDictionary) { (error, ref) in
                if error != nil {
//                    print("Error while saving the message sent")
                }else{
//                    print("Message sent successfully")
                }
                self.inputTextField.isSelectable = true
                self.sendButton.isEnabled = true
                self.inputTextField.text = ""
                
            }
      
        
        let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName).child("Messages")
        
        let messageDictionary2 = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp ": timeStamp,
                                  "SentMessage ": inputTextField.text!] as [String : Any]
        
            ref2.childByAutoId().setValue(messageDictionary2) { (error, ref) in
                if error != nil {
//                    print("Error while saving the message sent")
                }else{
                    print("TEXT Message sent successfully")
                }
                self.inputTextField.isSelectable = true
                self.sendButton.isEnabled = true
                self.inputTextField.text = ""
                
            }
        
//        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId)
//        badgeCountRef.updateChildValues(["Badge added ": "False"])
        
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil )
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMatches"{
            let VC = segue.destination as! UserTableViewController
            VC.femaleNames = femaleNames
            VC.firstNametextLable = firstNametextLable
            VC.IDs = IDs
            VC.profilePicURL = profilePicURL
        }
    }
   
    
  
}


extension ChatLogTableViewController : UITextViewDelegate {
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            self.inputTextField.text = ""
            self.inputTextField.textColor = UIColor.lightGray
            self.inputTextField.layer.cornerRadius = 10
            self.inputTextField.layer.borderColor = UIColor.darkGray.cgColor
            self.inputTextField.layer.borderWidth = 1
        }
        
    }

    func textViewDidChange(_ textView: UITextView) {
        if inputTextField.text.count > 0 {
            sendButton.isEnabled = true
        }
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = inputTextField.sizeThatFits(size)
        inputTextField.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
