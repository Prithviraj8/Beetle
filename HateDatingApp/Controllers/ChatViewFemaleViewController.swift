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
class ChatViewFemaleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var messageArray : [message] = [message]()
    var chatMessages = [FemaleChatMessage]()
    var sentMessages = [String]()
    
    var gender : String = ""
    var profilePic : String = ""
    var notificationPublisher = NotificationPublisher()
    var profilePicURL = [String]()
    var maleNames = [String]()
    var Ids = [String]()
    var firstNametextLable : String = ""
    var maleName : String = ""
    let userID = Auth.auth().currentUser?.uid
    var maleId : String = ""
    var age : Int!
    
    private var cellId = "customMessageCell"

    @IBOutlet weak var sendButton: UIButtonX!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var profilePicImage: UIImageViewX!
    @IBOutlet weak var BlockedMessage: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = maleName
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        messageTableView.register(FemaleChatLogTableViewCell.self, forCellReuseIdentifier: cellId)

        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        inputTextField.delegate = self

        configureTableView()

        setupKeyBoardObservers()
        retreiveMessage()
        inputTextField.keyboardAppearance = .light
        inputTextField.text = "Placeholder"
        inputTextField.textColor = UIColor.lightGray
        inputTextField.layer.cornerRadius = 10
        inputTextField.layer.borderColor = UIColor.gray.cgColor
        inputTextField.layer.borderWidth = 1
        textViewDidChange(inputTextField)

        profilePicImage.translatesAutoresizingMaskIntoConstraints = false
        profilePicImage.layer.masksToBounds = true
        profilePicImage.layer.cornerRadius = 22
        
        setupProfilePic()
        showKeyboard()
    }
    
    func setupProfilePic(){
        //Setting up Profie pic image.
        if let url = URL(string: profilePic){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Failed while fetching images : \(error?.localizedDescription)")
                    return
                }else {
                    DispatchQueue.main.async {
                        self.profilePicImage?.image = UIImage(data: data!)
                    }
                }
                
            }).resume()
        }
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        var ReceivedMessageTime = [Double]()
//        
//        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
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
//                        self.notificationPublisher.sendNotification(title: self.maleName, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: 1, delayInterval: 1)
//                        self.notificationPublisher.name = self.maleName
//                    }
//                }
//                
//                
//            }
//            
//        }
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
//            view.frame.origin.y = -(keyboardRect.height)/2
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
    
    func showKeyboard(){
        let isblockedRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(self.userID!).child(self.firstNametextLable).child(self.maleId)
        
        isblockedRef.observe(.value, with: { (snap1) in
            let snapValue = snap1.value as! NSDictionary
            if let blocked = snapValue["Blocked "] as? String {
                if blocked == "True"{
                    self.sendButton.isEnabled = false
                    self.sendButton.isHidden = true
                    self.inputTextField.isHidden = true
                    self.bottomView.isHidden = true
                }else{
                    self.BlockedMessage.isHidden = true
                }
            }else{
                self.BlockedMessage.isHidden = true
                
            }
        })
    }
    
    func retreiveMessage() {
        
        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
        
        messageDB.observeSingleEvent(of: .value) { (snap) in
            
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! NSDictionary

                
                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
                 
                    let message2 = FemaleChatMessage(text: ReceivedMessage as! String, isIncoming: true)
                    self.chatMessages.append(message2)
                    let messages = message()
                    messages.messageBody = ReceivedMessage as! String
                    self.messageArray.append(messages)
                    messageDB.child(snapshot.key).updateChildValues(["Message Read ": "True"])
                    messageDB.child(snapshot.key).updateChildValues(["Message Notified ": "True"])

                }
//                if let ReceivedMessage = snapshotValue["ReceivedImage "] {
//                    let message2 = FemaleChatMessage(text: ReceivedMessage as! String, isIncoming: true)
//                    self.chatMessages.append(message2)
//                    let messages = message()
//                    messages.messageBody = ReceivedMessage as! String
//                    self.messageArray.append(messages)
//                }

                if let SentMessage = snapshotValue["SentMessage "] {
                    
                    let message1 = FemaleChatMessage(text: SentMessage as! String, isIncoming: false)
                    self.chatMessages.append(message1)
                    let messages = message()
                    messages.messageBody = SentMessage as! String
                    self.messageArray.append(messages)
                    
                }
//                if let SentMessage = snapshotValue["SentImage "] {
//                    let message1 = FemaleChatMessage(text: SentMessage as! String, isIncoming: false)
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
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! FemaleChatLogTableViewCell
        let Message  = chatMessages[indexPath.row]

        cell.FemaleChatMessage = Message
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
        }else{
            
        }
        inputTextField.text = ""
//        inputTextField.endEditing(true)
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
        print("WE SELECTED AN IMAGE")
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
                    print("Error while uploading image : \(String(describing: error?.localizedDescription))")
                } else {
                    print("Successfully saved images to database : \(String(describing: metadata))")
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        
                        if err != nil {
                            
                            return
                        }
                        let downloadURL = url?.absoluteString
                        //                        let values = ["IMAGE SENT " : downloadURL!] as [String : AnyObject]
                        
                        var messages = message()
                        
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(self.maleId).child(self.maleName).child(self.userID!).child(self.firstNametextLable).child("Messages")
                        let timeStamp = NSDate().timeIntervalSince1970
                        let myTimeInterval = TimeInterval(timeStamp)
                        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
                        
                        print("TIME IS \(time)")
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
                        
                        
                        let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(self.userID!).child(self.firstNametextLable).child(self.maleId).child(self.maleName).child("Messages")
                        
                        let messageDictionary2 = ["SentImage " : downloadURL!,"Image Width ": image.size.width, "Image Height ": image.size.height] as [String : AnyObject]
                        
                        ref2.childByAutoId().setValue(messageDictionary2) { (error, ref) in
                            if error != nil {
//                                print("Error while saving the message sent")
                            }else{
                                print("IMAGE Message sent successfully")
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    func handleSend(){
        var messages = message()

        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(maleId).child(maleName).child(userID!).child(firstNametextLable).child("Messages")

        let timeStamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeStamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        print("TIME IS \(time)")

        messages.timeStamp = timeStamp
        let toId = messages.receiverID
        let messageDictionary = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp Received ": timeStamp,"ReceivedMessage ": inputTextField.text!,"Message Read ": "False","Message Notified ": "False"] as [String : Any]
        
        ref.childByAutoId().setValue(messageDictionary) { (error, ref) in
            if error != nil {
//                print("Error while saving the message sent")
            }else{
                print("TEXT Message sent successfully")
            }
            self.inputTextField.isSelectable = true
            self.sendButton.isEnabled = true
            self.inputTextField.text = ""
            
        }
        
        let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
        
        let messageDictionary2 = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp ": timeStamp,
                                  "SentMessage ": inputTextField.text!] as [String : Any]
        
        
        ref2.childByAutoId().setValue(messageDictionary2) { (error, ref) in
            if error != nil {
//                print("Error while saving the message sent")
            }else{
//                print("Message sent successfully")
            }
            self.inputTextField.isSelectable = true
            self.sendButton.isEnabled = true
            self.inputTextField.text = ""
            
        }
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMatches"{
            
            let VC = segue.destination as! UserTableFemaleTableViewController
            VC.maleNames = maleNames
            VC.firstNametextLable = firstNametextLable
            VC.Ids = Ids
            VC.profilePicURL = profilePicURL
            
        }
        
        if segue.identifier == "goToChatSettings" {
            
            let VC = segue.destination as! ChatSettingViewController
            VC.profilePic = profilePic
            VC.firstNameTextLabel = firstNametextLable
            VC.name = maleName
            VC.IDs = Ids
            VC.id = maleId
            VC.names = maleNames
            VC.profilePicURL = profilePicURL
            VC.gender = "Female"
            VC.age = age
        }
    }

}

extension ChatViewFemaleViewController : UITextViewDelegate {


    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            self.inputTextField.text = ""
            self.inputTextField.textColor = UIColor.lightGray
            self.inputTextField.layer.cornerRadius = 10
            self.inputTextField.layer.borderWidth = 1
            self.inputTextField.layer.borderColor = UIColor.gray.cgColor
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
