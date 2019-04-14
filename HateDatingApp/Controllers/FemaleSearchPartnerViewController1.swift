//
//  ViewController.swift
//  testingTinderSwipe
//
//  Created by Nicky on 11/16/17.
//  Copyright © 2017 Nicky. All rights reserved.
//

let  MAX_BUFFER_SIZE = 3;
let  SEPERATOR_DISTANCE = 8;
let  TOPYAXIS = 75;

import UIKit
import Firebase
import FirebaseStorage

class FemaleSearchPartnerViewController: UIViewController {
    
    
    @IBOutlet weak var emojiView: EmojiRateView!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var viewActions: UIView!
    @IBOutlet weak var dropMenuView: UIView!
    @IBOutlet weak var dropMenuButton: BadgeButton!
    @IBOutlet weak var matches: BadgeButton!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    
    var IDs = [String]()
    var profilePicOfLoggedInUser : String = ""
//    var ID : String = ""
    var age : Int!
    var userID = Auth.auth().currentUser?.uid
    var maleNamesMatched = [String]()
    var femaleNames = [String]()
    var namesSwippedByFemales = [String]()
    var currentIndex = 0
    var handler : Handler!
    var ref : DatabaseReference!
    var ref2 : DatabaseReference!
    var tinderCard : TinderCardFemale!
    var profilePic = [String]()
    var name = [String]()
    var firstNametextLable : String!
    var namesSwippedByMales = [String]()
    var maleName : String = ""
    var maleId : String = ""
    var messages = message()
    var receiverIds = [String]()
    
    var currentLoadedCardsArray = [TinderCardFemale]()
    var allCardsArray = [TinderCardFemale]()
    var cardArray = [UIView]()
    var notification = NotificationPublisher()
    var count : Int = 0
    var maleNames = [String]()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewActions.alpha = 0
        buttonUndo.alpha = 0
        fetchImagesAndPostThem()
        femaleSwippedMale(values: ["Name ": firstNametextLable as AnyObject])
        print("FIRST NAME is\(firstNametextLable) & USER ID IS \(userID)")
        initiateChat()
       
        messages.userID = userID
        messages.currentUserName = firstNametextLable
        messages.gender = "Female"
        dropMenuButton.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dropMenuButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        matches.setImage(UIImage(named: "Matches2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        matches.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        
        var USER = Auth.auth().currentUser;
        if USER!.isEmailVerified == false {
            USER?.sendEmailVerification(completion: { (error) in
                if error == nil {
                    print("SENT VERIFICATION TO \(USER?.email)")
                    self.alertTheUser(title: "Verification email sent", message: "Please verify your email.")
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        //loadCardValues()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil )
        let initialVC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        self.present(initialVC, animated: true, completion: nil)
        
    }
    
    @objc func animateEmojiView(timer : Timer){
        let sender = timer.userInfo as! EmojiRateView
        emojiView.rateValue =  emojiView.rateValue + 0.2
        if sender.rateValue >= 5 {
            timer.invalidate()
            emojiView.rateValue = 2.5
        }
    }

    func loadCardValues(pics: [String], names: [String], receiverIds: [String]) {
        
       
        if pics.count > 0 {
            
            let capCount = (pics.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : pics.count
            
            
            
            
            for (i,pic) in pics.enumerated() {
                //   for(i,name) in names.enumerated() {
                
                //            for i in 1...pics.count && && i < names.count {
                let newCard = createTinderCard(at: i,pic: pic,name: names[i],Id: receiverIds[i])
                
                //Checking value array.
                // print("The PIC IS ::  \(pic)")
                print("\(i): '\(pic)'")
                
                allCardsArray.append(newCard)
                //                currentLoadedCardsArray.append(newCard)
                
                //                Card.addSubview(allCardsArray[i])
                
                
                if i < capCount {
                    currentLoadedCardsArray.append(newCard)
                }
                
                //}
            }
           
            
            for (i,_) in currentLoadedCardsArray.enumerated() {
                if i > 0 {
                    viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                }else {
                    viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
                }
            }
            animateCardAfterSwiping()
            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
        }
        print("THE PROFILE PIC ARRAY IS EMPTY!!!!!!!")
        
    }
    
    @objc func loadInitialDummyAnimation() {
        
        let dummyCard = currentLoadedCardsArray.first;
        dummyCard?.shakeAnimationCard()
        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveLinear, animations: {
            self.viewActions.alpha = 1.0
        }, completion: nil)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.animateEmojiView), userInfo: emojiView, repeats: true)
    }
    
   
    func createTinderCard(at index: Int , pic :String, name: String,Id: String) -> TinderCardFemale {
        let card = TinderCardFemale(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic, name: name,Id: Id)
        user.name = name
        user.id = Id
        
        card.delegate = self as! TinderCardFemaleDelegate
        return card
    }
    
    func removeObjectAndAddNewValues() {
        
        emojiView.rateValue =  2.5
        UIView.animate(withDuration: 0.5) {
            self.buttonUndo.alpha = 0
        }
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        Timer.scheduledTimer(timeInterval: 1.01, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)
        
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
        }
        print(currentIndex)
        animateCardAfterSwiping()
    }
    
    func animateCardAfterSwiping() {
        
        for (i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                if i == 0 {
                    card.isUserInteractionEnabled = true
                }
                var frame = card.frame
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
                card.frame = frame
            })
        }
    }
    
    
    @IBAction func disLikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.leftClickAction()
        
    }
    
    
    @IBAction func LikeButtonAction(_ sender: Any) {
        
        let card = currentLoadedCardsArray.first
        card?.rightClickAction()
        
        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male").child(userID!)
        
        let ref = ref2.child(firstNametextLable).child(user.id).child(user.name)
        ref.observe(.value, with: { (snap) in
            if let value = snap.value as? NSDictionary {
                if let added = value["Added "] as? String {
                    if added != "True" {
                        self.initiateChat()
                    }
                }
            }
        })
        
    }
    
    @IBAction func undoButtonAction(_ sender: Any) {
        
        currentIndex =  currentIndex - 1
        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE {
            print("Current index is \(currentIndex)")
            print("current Loaded Cards array is \(currentLoadedCardsArray.count)")
            
            let lastCard = currentLoadedCardsArray.last
            lastCard?.rollBackCard()
            currentLoadedCardsArray.removeLast()
        }
        print("Current index is \(currentIndex)")
        let undoCard = allCardsArray[currentIndex]
        undoCard.layer.removeAllAnimations()
        viewTinderBackGround.addSubview(undoCard)
        undoCard.makeUndoAction()
        currentLoadedCardsArray.insert(undoCard, at: 0)
        animateCardAfterSwiping()
        if currentIndex == 0 {
            UIView.animate(withDuration: 0.5) {
                self.buttonUndo.alpha = 0
            }
        }
    }
    
    @objc func enableUndoButton(timer: Timer){
        
        let cardIntex = timer.userInfo as! Int
        if (currentIndex == cardIntex) {
            
            UIView.animate(withDuration: 0.5) {
                self.buttonUndo.alpha = 1.0
            }
        }
    }
    
    
    var menuShowing = false
    @IBAction func dropMenuPressed(_ sender: Any) {
        
        
        dropMenuView.layer.shadowOpacity = 1
        dropMenuView.layer.shadowRadius = 6
        
        if(menuShowing) {
            
            trailingConstraint.constant = 218
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else{
            trailingConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        menuShowing = !menuShowing
        
    }
    
//Fetching images and other info from firebase Database
    func fetchImagesAndPostThem() {
        var ref = Firebase.Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
        
        ref.observe(.value) { (snap) in
            print("SNAP \(snap.childrenCount)")
            
            let count = Int(snap.childrenCount)
           
            //   ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
            //Therefore we user observe which does the opposite.
            ref.observe(.childAdded, with: { (snapshot) in
                
                
                let snapshotValue = snapshot.value as! NSDictionary
                
                let pic = snapshotValue["Profile Pic "] as? String
                let NAME = snapshotValue["Name "] as? String
                let receiverId = snapshotValue["UserId "] as? String
                self.receiverIds.append(receiverId!)
                self.messages.receiverID = receiverId
                
                self.profilePic.append(pic!)
                self.name.append(NAME!)
                
  
                if self.profilePic.count == count {
                    self.loadCardValues(pics: self.profilePic, names: self.name,receiverIds: self.receiverIds)
                }
            })
            
            
        }
        
    }
    func femaleSwippedMale(values: [String: AnyObject]) {
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
        let usersChildRef = ref.child("users").child("FSM").child(userID!)
      
        usersChildRef.updateChildValues(values)

    }
    
    func initiateChat() {
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female")
        print("INITIATE CHAT")
        
        ref.observe(.childAdded, with: { (snapshot) in
            //            print("Users in Female swipped Male database are::\(snapshot) ")
            
            for name in snapshot.children {
                self.maleNames.append((name as AnyObject).key)
                let childSnap = name as! DataSnapshot
//                print("The male names are \(self.maleNames)")
//                print("KEYY IS : \(childSnap.key)")
                for females in childSnap.children {
                    let snap = females as! DataSnapshot
//                    print("The names of the females that this male-- \(name)  has liked are \(females)")
                    self.namesSwippedByMales.append((females as AnyObject).key)
                    
                    
                }
                for names in self.namesSwippedByMales {
//                    print("The names of males being checked are \(names)")
                    if(self.userID == names){
//                        print("YAYY THE HOT GUY::\(name) LIKES YOU::\(self.firstNametextLable)")

                        self.checkMatch(MaleId: snapshot.key, MaleName: childSnap.key)
                        break;
                        
                    }
                    
                    
                    
                }
                
            }
        })
    }

    func checkMatch(MaleId: String,MaleName : String) {
        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male").child(userID!)
        

        ref2.observe(.childAdded) { (snapshot) in
            for maleId in snapshot.children {
//                if snapshot.key == self.firstNametextLable {
                if (maleId as AnyObject).key == MaleId {
                    
                    let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child(MaleId)
                    ref.observeSingleEvent(of: .value) { (snap) in
                        let snapshotValue = snap.value as! NSDictionary
                        let profilePicURl = snapshotValue["Profile Pic "]
                        
                        self.matchFound(MaleId: MaleId, MaleName: MaleName, pic: profilePicURl as! String)
                        
                    }
                    }
//                }
            }
        }
    }

    func matchFound(MaleId: String,MaleName : String,pic: String) {

        messages.profilePicURL.append(pic)
        messages.IDS.append(MaleId)
        messages.finalMatch.append(MaleName)
        messages.maleName = MaleName
        messages.maleId = MaleId
        messages.imageURL = pic
        
        notification.name = MaleName
        notification.id = MaleId
        notification.firstNametextLable = firstNametextLable
        
        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(MaleId)
        badgeCountRef.updateChildValues(["Badge ": 1])
        badgeCountRef.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            if  let badgeAdded = snapshotValue!["Badge added "] as? String {
            }else{
                self.messages.badgeCount = self.messages.badgeCount + 1
                self.dropMenuButton.badge = self.messages.badgeCount
                self.matches.badge = self.messages.badgeCount
                print("BADGE COUNT IS \(self.messages.badgeCount)")

                if self.messages.badgeCount == 1 {
                    self.messages.oneMatch_Name = MaleName
                    self.messages.profilePic = pic
                    self.notification.sendNotification(title: "Match found", subtitle: "You have a new match", body: "You have been matched with \(MaleName)", badge: 1, delayInterval: 1)
                    self.performSegue(withIdentifier: "PopUpMatch", sender: self)

                }else{
                    self.notification.sendNotification(title: "Multiple Matches found", subtitle: "Check out your matches page.", body: "", badge: 1, delayInterval: 1)
//                    self.performSegue(withIdentifier: "PopUpMatch", sender: self)

                }
                

            }
            
            
        }
        showMessageBadge(MaleID: MaleId, MaleName: MaleName)
        presentVC(MaleID: MaleId, MaleName: MaleName)
    }
    func showMessageBadge(MaleID: String,MaleName: String){
        
        
        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(MaleID).child(MaleName).child("Messages")
        
        badgeCountRef.observe(.childAdded) { (snap) in
            let snapshotValue = snap.value as! NSDictionary
            if let message = snapshotValue["ReceivedMessage "] as? String {
                let messageRead = snapshotValue["Message Read "] as! String
                print("MES NOT \(messageRead)")
                if messageRead == "False" {
                    self.messages.badgeCount = self.messages.badgeCount + 1
                    self.messages.messageCount = self.messages.messageCount + 1
                    self.dropMenuButton.badge = self.messages.badgeCount
                    self.matches.badge = self.messages.messageCount

                }
                
            }
        }
    }
    
    
    func presentVC(MaleID: String,MaleName: String){
        let notificationPressed = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(MaleID)
        notificationPressed.observe(.value) { (snap) in
            let snapValue = snap.value as! NSDictionary
            if let notifyPressed = snapValue["Pressed "] as? String {
                if notifyPressed == "True" {
//                    print("NOTIFY PRESSED \(notifyPressed) from \(MaleName)")
                    self.messages.maleId = MaleID
                    self.messages.maleName = MaleName
                    self.performSegue(withIdentifier: "goToChatsDirectly", sender: self)
                    notificationPressed.updateChildValues(["Pressed ": "False"])
                }
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var finalMatch =  [String]()

        if segue.identifier == "goToMatches" {
            let destinationVC = segue.destination as! UserTableFemaleTableViewController
            destinationVC.firstNametextLable = self.firstNametextLable
            destinationVC.Ids = messages.IDS
            destinationVC.maleNames = messages.finalMatch
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.gender = "Female"
            destinationVC.age = age
        }
        
        if segue.identifier == "goToSettings" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = "Female"
        }
        if segue.identifier == "goToChatsDirectly" {
            let destinationVC = segue.destination as! ChatViewFemaleViewController
            
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.maleNames = messages.finalMatch
            destinationVC.Ids = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.age = age
            destinationVC.gender = "Male"
            destinationVC.maleId = messages.maleId
            destinationVC.maleName = messages.maleName
        }
        
        if segue.identifier == "PopUpMatch" {
            let destinationVC = segue.destination as! PopNewMatchViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.femaleNames = messages.finalMatch
            destinationVC.Name = messages.oneMatch_Name
            destinationVC.IDs = messages.IDS
            destinationVC.pic = messages.profilePic
            destinationVC.gender = "Female"
        }
        if segue.identifier == "ProfileUpdate"{
            let destinationVC = segue.destination as! ProfileUpdateViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = "Female"
            
        }

        if segue.identifier == "PotentialMatch" {
            let destinationVC = segue.destination as! PotentialMatchVC
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = "Male"
            destinationVC.currentUserGender = "Female"
        }
        
    }

    
    @IBAction func matchesPressed(_ sender: Any) {
        if messages.finalMatch.count>0{
            performSegue(withIdentifier: "goToMatches", sender: self)
        }else{
            alertTheUser(title: "You have no matches. Keep swiping 🥰", message: "")
        }
    }
    
    
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension FemaleSearchPartnerViewController : TinderCardFemaleDelegate{
    
    // action called when the card goes to the left.
    func cardGoesLeft(card: TinderCardFemale) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: TinderCardFemale) {
        removeObjectAndAddNewValues()
    }
    func currentCardStatus(card: TinderCardFemale, distance: CGFloat) {
        
        if distance == 0 {
            emojiView.rateValue =  2.5
        }else{
            let value = Float(min(fabs(distance/100), 1.0) * 5)
            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
            emojiView.rateValue =  sorted
        }
        
        
    }
}


