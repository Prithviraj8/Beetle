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

    @IBOutlet weak var messageTVHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButtonX!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var profilePicImage: UIImageViewX!
    @IBOutlet weak var BlockedMessage: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var gotBlockedMessage: UILabel!
    
    var bottomViewOriginalPos : CGFloat! = nil
    var messageTableViewOriginalPos : CGFloat! = nil
    var originalMessageTVHeight : CGFloat! = nil
    
    var bottomViewBottomAnchor : NSLayoutConstraint?
    var inputViewBottomAnchor : NSLayoutConstraint?
    var messageTVBottomAnchor : NSLayoutConstraint?
    
    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: .UIApplicationWillTerminate, object: nil)
    }
    
    @objc func handleEnterForeground(){
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName)
        inMessageVC.updateChildValues(["In Message VC ": "True "])
    }
    
    @objc func handleEnterBackground(){
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName)
        inMessageVC.updateChildValues(["In Message VC ": "False "])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        
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
        inputTextField.text = "Enter Message"
//        sendButton.isEnabled = false
//        inputTextField.textColor = UIColor.lightGray
        inputTextField.layer.cornerRadius = 10
        inputTextField.layer.borderColor = UIColor.flatYellowColorDark().cgColor
        inputTextField.layer.borderWidth = 1
        textViewDidChange(inputTextField)
        textViewDidBeginEditing(inputTextField)
        
        profilePicImage.translatesAutoresizingMaskIntoConstraints = false
        profilePicImage.layer.masksToBounds = true
        profilePicImage.layer.cornerRadius = 20
        profilePicImage.contentMode = .scaleAspectFill
        
        setupProfilePic()
        showKeyboard()
        BlockedMessage.isHidden = true
        
        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!)
        let value = ["First Name ": firstNametextLable, "Male name ": maleName, "Male Id ": maleId]
        messageDB.updateChildValues(value)
        let inMessageVC = messageDB.child(firstNametextLable).child(maleId).child(maleName)
        inMessageVC.updateChildValues(["In Message VC ": "True "])
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            if self.messageArray.count > 0{
                let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
            }
        })
        messageTableView.keyboardDismissMode = .interactive
//        originalMessageTVHeight = messageTVHeight.constant
        bottomViewBottomAnchor = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageTVBottomAnchor = messageTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        bottomViewBottomAnchor?.isActive = true
        messageTVBottomAnchor?.isActive = true
        
        bottomView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.skyBlue)

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
    
    override func viewDidDisappear(_ animated: Bool) {
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName)
        
        inMessageVC.updateChildValues(["In Message VC ": "False "])

    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        //        guard let keyboardDuration = ((notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]) as AnyObject).double else{
        //            return
        //        }
        
        let keyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            bottomViewBottomAnchor?.constant = -keyboardRect.height
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if self.messageArray.count > 0{
                    let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                    self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
                
            }
        }else if notification.name == Notification.Name.UIKeyboardWillHide {
            
//            messageTVHeight.constant = originalMessageTVHeight
            bottomViewBottomAnchor?.constant = 0
            messageTVBottomAnchor?.constant = 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if keyboardShowing {
                    if self.messageArray.count > 0{
                        let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                        self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                    }
                    
                }
            }
        }
    }
    
    
    func showKeyboard(){
        let isblockedRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId)
        
        isblockedRef.observeSingleEvent(of: .value, with: { (snap1) in
            let snapValue = snap1.value as! NSDictionary
            if let blocked = snapValue["Blocked "] as? String {
                if blocked == "True" {
                    print("BLOCKED IS \(blocked)")
                    self.sendButton.isEnabled = false
                    self.sendButton.isHidden = true
                    self.inputTextField.isHidden = true
                    self.bottomView.isHidden = true
                    self.BlockedMessage.isHidden = false
                    self.BlockedMessage.text = "You've blocked this user. Unblock him to send message."
                }else{
                    self.BlockedMessage.isHidden = true
                }
            }else{
                self.BlockedMessage.isHidden = true
            }
        })
        
        let blockedRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(self.maleId).child(self.maleName).child(self.userID!)
        print("HEEEEE")
        blockedRef.observe(.value) { (snapshot) in
            if let snapshotValue = snapshot.value as? NSDictionary {
            if let blocked = snapshotValue["Blocked "] as? String {
                if blocked == "True"{
                    self.sendButton.isEnabled = false
                    self.sendButton.isHidden = true
                    self.inputTextField.isHidden = true
                    self.bottomView.isHidden = true
                    self.gotBlockedMessage.isHidden = false
                    self.gotBlockedMessage.text = "This user has blocked you so you cannot send him any messages."
                    
                }else{
                    self.gotBlockedMessage.isHidden = true
                }
            }
            else{
                self.gotBlockedMessage.isHidden = true

            }
            }
            
        }
    }
    
    func retreiveMessage() {
        
        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(maleId).child(maleName).child("Messages")
        let DB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(maleName).child(maleId).child(firstNametextLable).child(userID!).child("Messages")            
            
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
                    messageDB.child(snapshot.key).updateChildValues(["Text Widht ": (ReceivedMessage as! String).count])
                  
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
                        if self.messageArray.count > 0{
                            let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                            self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                        }
                        
                    })
                    
                    
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
                    messageDB.child(snapshot.key).updateChildValues(["Text Widht ": (SentMessage as! String).count])
                    
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
                        if self.messageArray.count > 0{
                            let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                            self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                        }
                        
                    })
                    
                    
                   
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
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! FemaleChatLogTableViewCell
        let Message  = chatMessages[indexPath.row]

        cell.FemaleChatMessage = Message
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let size = estimateFrameForText(text: Message.text)
        
//        if size.width >= 150 {
//            cell.messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
//        }

        
        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(maleId).child(maleName).child(userID!).child(firstNametextLable).child("Messages")
        messageDB.observe(.childAdded, with: { (snap1) in
            
            if let snapshotValue = snap1.value as? NSDictionary {
                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
                    let messageRead = snapshotValue["Message Read "] as! String
                    
                    if messageRead == "True"{
                        print("MESSAGE on cell IS \(cell.messageLabel.text)")
                        if cell.messageLabel.text == ReceivedMessage as? String{
                            UIView.animate(withDuration: 0.5, animations: {
                                cell.bubbleView.backgroundColor = UIColor(red: 0, green: 0.7412, blue: 0.9686, alpha: 1.0)
                            })
                        }
                        
                    }else{
                        if cell.messageLabel.text == ReceivedMessage as? String{
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                cell.bubbleView.backgroundColor = UIColor.gray
                            })
                            
                        }
                    }
                    
                    
                }
                
            }
            
        })

        
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

        handleSend()
        inputTextField.text = ""
//        if messageArray.count > 0{
//            let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
//            self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
//        }
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
                            self.sendButton.isEnabled = false
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
            self.sendButton.isEnabled = false
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
            self.sendButton.isEnabled = false
            self.inputTextField.text = ""
            
        }
    }
    

    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMatches"{
            
            let VC = segue.destination as! UserTableFemaleTableViewController
            VC.maleNames = maleNames
            VC.firstNametextLable = firstNametextLable
            VC.Ids = Ids
            VC.profilePicURL = profilePicURL
            dismiss(animated: true, completion: nil)

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
            self.inputTextField.textColor = UIColor.black
            self.inputTextField.layer.cornerRadius = 10
            self.inputTextField.layer.borderWidth = 1
            self.inputTextField.layer.borderColor = UIColor.flatYellowColorDark().cgColor
        }

    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            sendButton.isEnabled = false
        }else{
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
