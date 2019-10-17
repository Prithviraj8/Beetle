//
//  ChatLogController.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
//        private var cellId = "customMessageCell"
    private func setupNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground), name: .UIApplicationWillTerminate, object: nil)
    }
    @IBOutlet weak var inputTextField: UITextView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var ChatName: UILabel!
    @IBOutlet weak var Blocked: UILabel!
    @IBOutlet weak var chatSetting: UIButton!
    @IBOutlet weak var GotBlocked: UILabel!
    
    
    @objc func handleEnterForeground(){
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(userID!).child(firstNametextLable).child(id).child(name)
        inMessageVC.updateChildValues(["In Message VC ": true])
        print("WERE INNNN FOREEE")
    }
    
    @objc func handleEnterBackground(){
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(userID!).child(firstNametextLable).child(id).child(name)
        inMessageVC.updateChildValues(["In Message VC ": false])
        print("WERE INNNN FOREEE")
    }
    
        let cellId = "customMessageCell"
        var profilePicURL = [String]()
        var firstNametextLable : String = ""
        var id : String = ""
        var IDs = [String]()
        let userID = Auth.auth().currentUser?.uid
        var name : String = ""
        var names = [String]()
        var profilePic : String = ""
        var age : Int!
        var currentUsersGender : String = ""
        var gender : String = ""
        var bottomViewBottomAnchor : NSLayoutConstraint?
        var messageTVBottomAnchor : NSLayoutConstraint?
    
    var user = User()
    
    var messages = [Message]()
    var allMess = message()
    let count = message()
    var messageArray : [message] = [message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ChatName.text = name
        
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(userID!).child(firstNametextLable).child(id).child(name)
        inMessageVC.updateChildValues(["In Message VC ": true])
        
        messageView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //        messageView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        messageView.alwaysBounceVertical = true
        messageView?.backgroundColor = UIColor.white
        messageView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        messageView.delegate = self
        messageView.dataSource = self
        inputTextField.delegate = self
        messageView?.keyboardDismissMode = .interactive
        print("FEMALE NAME)")

        setupNotificationObservers()
        setupKeyBoardObservers()
        observeMessages()
        textViewDidChange(inputTextField)
        textViewDidBeginEditing(inputTextField)
        setupProfilePic()
        
        bottomViewBottomAnchor = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        messageTVBottomAnchor = messageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        chatSetting.layer.cornerRadius = chatSetting.frame.width/2.0
        checkIfBlocked()
    }
    
    
    @IBAction func goToChatSetting(_ sender: Any) {
        performSegue(withIdentifier: "goToChatSetting", sender: self)
    }
        @IBAction func backButtonPressed(_ sender: Any) {
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "BackToMatches", sender: self)
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
                            self.chatSetting.contentMode = .scaleAspectFit
                            self.chatSetting?.setImage(UIImage(data: data!)?.withRenderingMode(.alwaysOriginal), for: .normal)
                        }
                    }
    
                }).resume()
            }
        }
    
   
    func checkIfBlocked(){
        let isblockedRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(self.userID!).child(self.firstNametextLable).child(id)
        
        isblockedRef.observe(.value, with: { (snap1) in
            let snapValue = snap1.value as! NSDictionary
            if let blocked = snapValue["Blocked "] as? String {
                if blocked == "True"{
                    self.sendButton.isEnabled = false
                    self.sendButton.isHidden = true
                    self.inputTextField.isHidden = true
                    self.bottomView.isHidden = true
                    self.Blocked.isHidden = false
//                    self.BlockedMessage.text = "You've blocked this user. Unblock her to send messages."
                }else{
                    self.Blocked.isHidden = true
                }
            }else{
                self.Blocked.isHidden = true
                
            }
        })
        
        let blocked = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(gender).child(id).child(name).child(self.userID!)
        print("HEEEEE")
        blocked.observe(.value) { (snapshot) in
            if let snapValue = snapshot.value as? NSDictionary{
                if let blocked = snapValue["Blocked "] as? String {
                    if blocked == "True"{
                        self.sendButton.isEnabled = false
                        self.sendButton.isHidden = true
                        self.inputTextField.isHidden = true
                        self.bottomView.isHidden = true
                        self.GotBlocked.isHidden = false
//                        self.gotBlockedMessage.text = "This user has blocked you so you cannot send her any messages."
                        
                    }else{
                        self.GotBlocked.isHidden = true
                    }
                }else{
                    self.GotBlocked.isHidden = true
                    
                }
                
            }
            
        }
    }

    
    func observeMessages() {
        
        user.id = id
//        guard let uid = Auth.auth().currentUser?.uid, let toId = user.id else {
//            return
//        }
        print("FEMALE NAME \(name)")
        count.count = count.count + 1
        let userMessagesRef = Database.database().reference().child("users").child("Match").child(currentUsersGender).child(Auth.auth().currentUser!.uid).child(firstNametextLable).child(id).child(name).child("Messages")
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            if let fromId = value!["fromId"] as? String{
                if Auth.auth().currentUser?.uid != fromId {
                    userMessagesRef.child(snapshot.key).updateChildValues(["Message Read ": true])
                    userMessagesRef.child(snapshot.key).updateChildValues(["Message Notified ": true])
                }
                
            }
            
            
            let messageId = snapshot.key
            let messagesRef = userMessagesRef.child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                print("DICTIONARY is \(dictionary)")
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    self.messageView.reloadData()
//                    scroll to the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.messageView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    

    
//    lazy var inputContainerView: ChatInputContainerView = {
//        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
//        chatInputContainerView.chatLogController = self
//        return chatInputContainerView
//    }()
    @IBAction func sendImage(_ sender: Any) {
        handleUploadTap()
    }
    
     func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]

        present(imagePickerController, animated: true, completion: nil)
    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
//        handleImageSelectedForInfo(info as [String : AnyObject])


        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            //we selected a video
            handleVideoSelectedForUrl(videoUrl)
        } else {
            print("we selected an image")
            handleImageSelectedForInfo(info as [String : AnyObject])

        }
        dismiss(animated: true, completion: nil)

    }
 

     func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
        let ref = Storage.storage().reference().child("message_movies").child(filename)
        let uploadTask = ref.putFile(from: url, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload movie:", err)
                return
            }
            
            ref.downloadURL(completion: { (downloadUrl, err) in
                if let err = err {
                    print("Failed to get download url:", err)
                    return
                }
                
                guard let downloadUrl = downloadUrl else { return }
                print("DOWN is \(downloadUrl)")
                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                        let properties: [String: Any] = ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": downloadUrl.absoluteString]
                        self.sendMessageWithProperties(properties)
                        
                    })
                }
                
            })
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user.name
        }
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
     func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        print("we selected an image")

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
//            dismiss(animated: true, completion: nil)

    }
    
     func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference(forURL: "gs://beetle-5b79a.appspot.com/").child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData as Data, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    let downloadURL = url?.absoluteString

                    completion(url?.absoluteString ?? "")
                })
                
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUsersGender).child(userID!).child(firstNametextLable).child(id).child(name)
        inMessageVC.updateChildValues(["In Message VC ": false])
        NotificationCenter.default.removeObserver(self)
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
        
        
        let keyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            print("KEYBOARD is \(keyboardRect.height)")
            bottomViewBottomAnchor?.constant = -keyboardRect.height
            bottomViewBottomAnchor?.isActive = true
            print("VIEW HEIGHT IS \(bottomViewBottomAnchor?.constant)")

            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if self.messages.count > 0{
                    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                    self.messageView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: false)
                }
                
            }
        }else if notification.name == Notification.Name.UIKeyboardWillHide {
            
            bottomViewBottomAnchor?.constant = 0
            messageTVBottomAnchor?.constant = 0
//            bottomViewBottomAnchor!.isActive = true

            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if keyboardShowing {
                    if self.count.count > 0{
                        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                        self.messageView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: false)
                    }
                    
                }
            }
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("MESSAEGE \(messages.count)")

        return messages.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        
        cell.message = message
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            //a text message
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }
    
    fileprivate func setupCell(cell: ChatMessageCell, message: Message) {
        cell.profileImageView.loadImageUsingCacheWithUrlString(profilePic)
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        messageView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil )
    }
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    @IBAction func sendButton(_ sender: Any) {
        handleSend()
        
    }
     func handleSend() {
        if inputTextField.text != ""{
            let properties = ["text ": inputTextField.text!]
            sendMessageWithProperties(properties as [String : AnyObject])
        }
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        
        print("SENDING IMAGEEE   \(imageUrl)")
        sendMessageWithProperties(properties)
    }
    fileprivate func sendMessageWithProperties(_ properties: [String: Any]) {
        let ref = Database.database().reference().child("users").child("Match").child(currentUsersGender).child(Auth.auth().currentUser!.uid).child(firstNametextLable).child(id).child(name).child("Messages")
        let childRef = ref.childByAutoId()
        let toId = id
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: Any] = ["toId": toId, "fromId": fromId, "timestamp": timestamp]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        
        
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
             let messageId = childRef.key
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageId)
            recipientUserMessagesRef.setValue(1)
        }
        
        let messages = message()
            let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(gender).child(id).child(name).child(userID!).child(firstNametextLable).child("Messages")
           
            
        
//            var messageDictionary = ["fromId": userID,"toID": toId,"Time Stamp Received ": timestamp, "Message Read ": "False","Message Notified ": "False"] as [String : Any]
        var messageDictionary = ["fromId": userID,"toID": toId,"Time Stamp Received ": timestamp, "Message Read ": false,"Message Notified ": false] as [String : Any]

            properties.forEach({messageDictionary[$0] = $1})

            
            ref2.childByAutoId().setValue(messageDictionary) { (error, ref) in
                if error != nil {
                    //                print("Error while saving the message sent")
                }else{
                    print("TEXT Message sent successfully")
                }
                self.inputTextField.isSelectable = true
                self.sendButton.isEnabled = false
                self.inputTextField.text = ""
                
            }
        }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        handleSend()
//        return true
//    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    //my custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
//                self.inputContainerView.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                //                    do nothing
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
//                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "BackToMatches"{
                let VC = segue.destination as! UserTableViewController
                VC.MatchedNames = names
                VC.firstNametextLable = firstNametextLable
                VC.IDs = IDs
                VC.profilePicURL = profilePicURL
                VC.gender = gender
                VC.currentUsersGender = currentUsersGender
            }
         
            if segue.identifier == "goToChatSetting" {
    
                let VC = segue.destination as! ChatSettingViewController
                VC.profilePic = profilePic
                VC.firstNameTextLabel = firstNametextLable
                VC.name = name
                VC.IDs = IDs
                VC.id = id
                VC.names = names
                VC.profilePicURL = profilePicURL
                VC.currentUsersGender = currentUsersGender
                VC.gender = gender
                VC.age = age
            }
        }
    
    
}





extension ChatLogController : UITextViewDelegate {


    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            if self.inputTextField.text == "Enter Message" {
                self.inputTextField.text = ""
            }
            self.inputTextField.textColor = UIColor.black
            self.inputTextField.layer.cornerRadius = 10
            self.inputTextField.layer.borderColor = UIColor.flatYellowColorDark().cgColor
            self.inputTextField.layer.borderWidth = 1
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
                if estimatedSize.height < CGFloat(60){

                    constraint.constant = estimatedSize.height
                }
            }
        }
    }


}









//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary<Key: Hashable, Any>(uniqueKeysWithValues: input.map {(arg) -> Result in let (key, value) = arg; return (key.rawValue, value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
//    guard let input = input else { return nil }
//    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
//    return input.rawValue
//}
