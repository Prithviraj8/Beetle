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
    
    
    private var cellId = "customMessageCell"

    var profilePicURL = [String]()
    var firstNametextLable : String = ""
    var femaleId : String = ""
    var IDs = [String]()
    let userID = Auth.auth().currentUser?.uid
    var femaleName : String = ""
    var femaleNames = [String]()
    var profilePic : String = ""
    var age : Int!
    var gender : String = ""
    var alphabet: String = "abcdefghijklmnopqrstuvwxyz"

    private let notificationPublisher = NotificationPublisher()
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var BlockedMessage: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var profilePicImage: UIImageViewX!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var gotBlockedMessage: UILabel!
   
    var bottomViewOriginalPos : CGFloat! = nil
    var messageTableViewOriginalPos : CGFloat! = nil
    var originalMessageTVHeight : CGFloat! = nil
    
    var bottomViewBottomAnchor : NSLayoutConstraint?
    var inputViewBottomAnchor : NSLayoutConstraint?
    var messageTVBottomAnchor : NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.layer.masksToBounds = true
        navigationBar.topItem?.title = femaleName
//        navigationController?.navigationBar.prefersLargeTitles = true

//        sendButton.isEnabled = false
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
        inputTextField.text = "Enter Message"
        inputTextField.textColor = UIColor.black
        inputTextField.layer.cornerRadius = 10
        inputTextField.layer.borderColor = UIColor.flatYellowColorDark().cgColor
        inputTextField.layer.borderWidth = 1
        
        profilePicImage.translatesAutoresizingMaskIntoConstraints = false
        profilePicImage.layer.masksToBounds = true
        profilePicImage.layer.cornerRadius = 20
        profilePicImage.contentMode = .scaleAspectFill

        //Setting up Profie pic image.
        uiViewDidChange(bottomView)
        setupProfilePic()
        showKeyBoard()
        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!)
        let value = ["First Name ": firstNametextLable, "Female name ": femaleName, "Female Id ": femaleId]
        let inMessageVC = messageDB.child(firstNametextLable).child(femaleId).child(femaleName)
        inMessageVC.updateChildValues(["In Message VC ": "True "])
        messageDB.updateChildValues(value)
        

        messageTableView.keyboardDismissMode = .interactive
        
        bottomViewOriginalPos = bottomView.frame.origin.y
        messageTableViewOriginalPos = messageTableView.frame.origin.y
        bottomViewBottomAnchor = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageTVBottomAnchor = messageTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        messageTVBottomAnchor?.isActive = true
        bottomViewBottomAnchor?.isActive = true
 
        bottomView.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.skyBlue)
        
        
        
}

    override func viewDidDisappear(_ animated: Bool) {
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName)
        inMessageVC.updateChildValues(["In Message VC ": "False "])

    }
    
    func setupProfilePic(){
        //Setting up Profie pic image.
        let profileImage = UIImageView()
        navigationItem.titleView = profileImage
        navigationItem.title = femaleName
        profileImage.contentMode = .scaleAspectFit
        
        profileImage.frame = CGRect(x: 308, y: 45, width: 44, height: 44)
//        profileImage.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: -37).isActive = true
//        profileImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        profileImage.widthAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
//        profileImage.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
//
//
        let backButton = UIButton(type: .system)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.setImage(UIImage(named: "BACK1")?.withRenderingMode(.alwaysOriginal), for:  .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
        
        if let url = URL(string: profilePic){
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("Failed while fetching images : \(error?.localizedDescription)")
                    return
                }else {
                    DispatchQueue.main.async {
                        self.profilePicImage.contentMode = .scaleAspectFit
                        self.profilePicImage.image = UIImage(data: data!)
                    }
                }
                
            }).resume()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return messageArray.count
        
        return chatMessages.count
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
                    self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                }
                
            }
        }else if notification.name == Notification.Name.UIKeyboardWillHide {

            bottomViewBottomAnchor?.constant = 0
            messageTVBottomAnchor?.constant = 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if keyboardShowing {
                    if self.messageArray.count > 0{
                        let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                        self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                    }
                    
                }
            }
        }
    }
    

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func showKeyBoard(){
        let isblockedRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(self.userID!).child(self.firstNametextLable).child(self.femaleId)
        
        isblockedRef.observe(.value, with: { (snap1) in
            let snapValue = snap1.value as! NSDictionary
            if let blocked = snapValue["Blocked "] as? String {
                if blocked == "True"{
                    self.sendButton.isEnabled = false
                    self.sendButton.isHidden = true
                    self.inputTextField.isHidden = true
                    self.bottomView.isHidden = true
                    self.BlockedMessage.isHidden = false
                    self.BlockedMessage.text = "You've blocked this user. Unblock her to send messages."
                }else{
                    self.BlockedMessage.isHidden = true
                }
            }else{
                self.BlockedMessage.isHidden = true

            }
        })
        
        let blocked = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(self.femaleId).child(self.femaleName).child(self.userID!)
        print("HEEEEE")
        blocked.observe(.value) { (snapshot) in
            if let snapValue = snapshot.value as? NSDictionary{
                if let blocked = snapValue["Blocked "] as? String {
                if blocked == "True"{
                    self.sendButton.isEnabled = false
                    self.sendButton.isHidden = true
                    self.inputTextField.isHidden = true
                    self.bottomView.isHidden = true
                    self.gotBlockedMessage.isHidden = false
                    self.gotBlockedMessage.text = "This user has blocked you so you cannot send her any messages."

                }else{
                    self.gotBlockedMessage.isHidden = true
                }
            }else{
                self.gotBlockedMessage.isHidden = true
                
            }

            }
            
        }
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
        storageRef = Storage.storage().reference(forURL: "gs://beetle-5b79a.appspot.com/").child("images_sent").child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            
            storageRef.putData(uploadData as Data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error while uploading image : \(String(describing: error?.localizedDescription))")
                } else {
                    print("Successfully saved images to database : \(String(describing: metadata))")
          
                    storageRef.downloadURL(completion: { (url, err) in
                        
                        if err != nil {
                            
                            print("Error while downloadingURL : \(err?.localizedDescription)")
                            return
                        }
                        let downloadURL = url?.absoluteString
                       
                        let messages = message()
                        
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(self.femaleId).child(self.femaleName).child(self.userID!).child(self.firstNametextLable).child("Messages")
                        let timeStamp = NSDate().timeIntervalSince1970
                        
                        messages.timeStamp = timeStamp
                        let messageDictionary = ["ReceivedImage " : downloadURL!,"Image Width ": image.size.width, "Image Height ": image.size.height,"Message Read ": "False","Message Notified ": "False"] as [String : AnyObject]

                        messages.imageHeight = image.size.height as NSNumber
                        messages.imageWidth = image.size.width as NSNumber
                        
                        ref.childByAutoId().setValue(messageDictionary) { (error, ref) in
                            if error != nil {
                                print("Error while saving the message sent")
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
        
        var count = 0;
//        messageDB.observe(.value) { (snap) in
        
            
            messageDB.observe(.childAdded) { (snapshot) in
                
                let snapshotValue = snapshot.value as! NSDictionary
                
         
                            if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
                                
                                let message2 = ChatMessage(text: ReceivedMessage as! String, isIncoming: true)
                                self.chatMessages.append(message2)
                                let messages = message()
                                messages.messageBody = ReceivedMessage as! String
                                self.messageArray.append(messages)
//                                print("RE MESS ID \(snapshot.key)")
                                
                                
                                messageDB.child(snapshot.key).updateChildValues(["Message Read ": "True"])
                                messageDB.child(snapshot.key).updateChildValues(["Message Notified ": "True"])
                                messageDB.child(snapshot.key).updateChildValues(["Text Widht ": (ReceivedMessage as! String).count])
                                
                                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                                    if self.messageArray.count > 0{
                                        let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
                                        self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
                                    }
                                    
                                })
                                
                }
                if let ReceivedMessage = snapshotValue["ReceivedImage "] {
                            
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
                                print("RE MESS ID \(snapshot.key)")
                                messageDB.child(snapshot.key).updateChildValues(["Text Widht ": (SentMessage as! String).count])
                            
                            }
                            
                                            if let SentMessage = snapshotValue["SentImage "] {
                            
                            
                                                let message1 = ChatMessage(text: SentMessage as! String, isIncoming: false)
                                                self.chatMessages.append(message1)
                                                let messages = message()
                                                messages.messageBody = SentMessage as! String
                                                self.messageArray.append(messages)
                                            }
                

                    self.configureTableView()
                    self.messageTableView.reloadData()
                
            }
            
//        }
    
        
    }
 
    let chat = ChatLogTableViewCell()
    var messages = message()
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // Work on cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatLogTableViewCell
        
        let Message  = chatMessages[indexPath.row]
        cell.chatMessage = Message
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let size = estimateFrameForText(text: Message.text )
        
//        if cell.messageLabel.text == Message.text {
//        if size.width >= 150 {
//            cell.messageLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
//            }
//        }

        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(femaleId).child(femaleName).child(userID!).child(firstNametextLable).child("Messages")
        messageDB.observe(.childAdded, with: { (snap1) in
            
            if let snapshotValue = snap1.value as? NSDictionary {
                if let ReceivedMessage = snapshotValue["ReceivedMessage "] {
                    let messageRead = snapshotValue["Message Read "] as! String
                    
                    if cell.messageLabel.text == ReceivedMessage as? String{
                    
                    if messageRead == "True"{
                            UIView.animate(withDuration: 0.5, animations: {
                                cell.bubbleView.backgroundColor = UIColor(red: 0, green: 0.7412, blue: 0.9686, alpha: 1.0)
                            })
                        
                    }else{

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
        
//        inputTextField.endEditing(true)
        handleSend()
        inputTextField.text = ""

        if messageArray.count > 0{
            let indexPath = NSIndexPath(item: self.messageArray.count - 1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        }
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
                self.sendButton.isEnabled = false
                self.inputTextField.text = ""
                
            }
      
        
        let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(femaleId).child(femaleName).child("Messages")
        
        let messageDictionary2 = ["Sender ID ": userID,"Receiver ID ": toId,"Time Stamp ": timeStamp,
                                  "SentMessage ": inputTextField.text!, "Text Widht ": (inputTextField.text.count )] as [String : Any]
        
            ref2.childByAutoId().setValue(messageDictionary2) { (error, ref) in
                if error != nil {
//                    print("Error while saving the message sent")
                }else{
                    print("TEXT Message sent successfully")
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
            let VC = segue.destination as! UserTableViewController
            VC.femaleNames = femaleNames
            VC.firstNametextLable = firstNametextLable
            VC.IDs = IDs
            VC.profilePicURL = profilePicURL
        }else if segue.identifier == "chatSettings" {

            let VC = segue.destination as! ChatSettingViewController
            VC.profilePic = profilePic
            VC.firstNameTextLabel = firstNametextLable
            VC.name = femaleName
            VC.IDs = IDs
            VC.id = femaleId
            VC.names = femaleNames
            VC.profilePicURL = profilePicURL
            VC.gender = "Male"
            VC.age = age
        }
    }
    
}


extension ChatLogTableViewController : UITextViewDelegate {
   
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            self.inputTextField.text = ""
            self.inputTextField.textColor = UIColor.black
            self.inputTextField.layer.cornerRadius = 10
            self.inputTextField.layer.borderColor = UIColor.flatYellowColorDark().cgColor
            self.inputTextField.layer.borderWidth = 1
        }
        
    }


    
    func textViewDidChange(_ textView: UITextView) {
        let letter = Array(alphabet)
            if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                sendButton.isEnabled = false
            }else{
                sendButton.isEnabled = true
            }
        
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = inputTextField.sizeThatFits(size)
        inputTextField.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height < CGFloat(60){
                    
                    constraint.constant = estimatedSize.height
                    messages.inputTextFieldHeight = CGFloat(estimatedSize.height)
                }
            }
        }
    }
    
    
    func uiViewDidChange(_ UIView: UIView){
        let size = CGSize(width: view.frame.width, height: .infinity)
        print("SIZE OF TEXT VIEW IS \(size)")
        let estimatedSize = bottomView.sizeThatFits(size)
        bottomView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = messages.inputTextFieldHeight + CGFloat(60)
            }
        }
    }
}
