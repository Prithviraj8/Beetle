//
//  ViewController.swift
//  testingTinderSwipe
//
//  Created by Nicky on 11/16/17.
//  Copyright © 2017 Nicky. All rights reserved.
//

let  MAX_BUFFER_SIZE1 = 3;
let  SEPERATOR_DISTANCE1 = 8;
let  TOPYAXIS1 = 75;

import UIKit
import Firebase
import FirebaseStorage

class SearchPartnerViewController: UIViewController {
    

    
    @IBOutlet weak var emojiView: EmojiRateView!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var buttonUndo: UIButton!
    @IBOutlet weak var viewActions: UIView!
    @IBOutlet weak var dropMenuView: UIView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropMenuButton: BadgeButton!
    @IBOutlet weak var matches: BadgeButton!
    @IBOutlet weak var YourProfileButtonView: UIView!
    
    var user = User()
    var age : Int!
    
    var IDs = [String]()
    var userID = Auth.auth().currentUser?.uid
    var currentIndex = 0
    var handler : Handler!
    var ref: DatabaseReference!
    var ref2 : DatabaseReference!
    var tinderCard : TinderCard!
    var profilePic = [String]()
    var name = [String]()
    var profilePicOfLoggedInUser : String!
    var firstNametextLable : String = ""
    var currentLoadedCardsArray = [TinderCard]()
    var allCardsArray = [TinderCard]()
    var cardArray = [UIView]()

    
//    var count : Int = 0
    var femaleIdsMatched = [String]()
    var receiverIds = [String]()
    var femaleNames = [String]()
    var namesSwippedByFemales = [String]()
    var namesSwippedByMales = [String]()
    var femaleNamesMatched = [String]()
    var notification = NotificationPublisher()
    var badge : Int!
    var NAME = names()
    let potentialMatches = potentialMatchedUsers()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        notification.notification()
        viewActions.alpha = 0
        buttonUndo.alpha = 0
        fetchImagesAndPostThem()
        maleSwippedFemale(values: ["Name " : self.firstNametextLable] as [String : AnyObject])
        initiateChat()
        messages.userID = userID
        messages.currentUserName = firstNametextLable
        messages.gender = "Male"

//        let dropMenuButton = BadgeButton()
//        dropMenuButton.frame = CGRect(x: 309, y: 20, width: 54, height: 39)
        dropMenuButton.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        checkPotentialMatches()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        //loadCardValues()
    }
    
    func getLoggedInUserInfo() -> String{
        return user.name

    }
    
    @objc func animateEmojiView(timer : Timer){
        let sender = timer.userInfo as! EmojiRateView
        emojiView.rateValue =  emojiView.rateValue + 0.2
        if sender.rateValue >= 5 {
            timer.invalidate()
            emojiView.rateValue = 2.5
        }
    }


    func loadCardValues(pics: [String], names: [String],receiverIds: [String]) {
        
        if pics.count > 0 {
            
            let capCount = (pics.count > MAX_BUFFER_SIZE1) ? MAX_BUFFER_SIZE1 : pics.count

            for (i,pic) in pics.enumerated() {
                    let newCard = createTinderCard(at: i,pic: pic,name: names[i],Id: receiverIds[i])
 
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
    

    func createTinderCard(at index: Int , pic :String, name: String, Id: String) -> TinderCard {
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic, name: name,Id : Id)
        card.delegate = self
        user.name = name
        user.id = Id
        return card
    }
    
    func removeObjectAndAddNewValues() {
        
        emojiView.rateValue =  2.5
        UIView.animate(withDuration: 0.5) {
            self.buttonUndo.alpha = 0
        }
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        print("Current index is \(currentIndex)")
        print("CURRENT LOADED COUNT IS \(currentLoadedCardsArray.count)")
        Timer.scheduledTimer(timeInterval: 1.01, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)
        
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE1 * SEPERATOR_DISTANCE1)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE1 - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE1 - 2])
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
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE1)
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
        
        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female").child(userID!)
        
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

        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE1 {
//            print("current Loaded Cards array is \(currentLoadedCardsArray.count)")
            
            let lastCard = currentLoadedCardsArray.last
            lastCard?.rollBackCard()
            currentLoadedCardsArray.removeLast()
        }
//        print("Current index is \(currentIndex)")
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

    var messages = message()
    func fetchImagesAndPostThem() {
        let ref = Firebase.Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female")
        
        ref.observe(.value) { (snap) in
//            print("SNAP \(snap.childrenCount)")
            
            var count = Int(snap.childrenCount)
            //                        ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
            //Therefore we user observe which does the opposite.
            ref.observe(.childAdded, with: { (snapshot) in
                
            
//                self.messages.receiverID = snapshot.key
                let snapshotValue = snapshot.value as! NSDictionary

                let pic = snapshotValue["Profile Pic "] as? String
                let NAME = snapshotValue["Name "] as? String
                let receiverId = snapshotValue["UserId "] as? String
                self.receiverIds.append(receiverId!)
                self.messages.receiverID = receiverId!
                self.profilePic.append(pic!)
                self.name.append(NAME!)

                if self.profilePic.count == count {
                    self.loadCardValues(pics: self.profilePic, names: self.name, receiverIds: self.receiverIds)
                }
            })
            
       
            
        }
        
    }
    
  
    
    func maleSwippedFemale(values: [String: AnyObject]) {
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
        let usersChildRef = ref.child("users").child("MSF").child(userID!)
       // TinderCard.getLoggedInUserName()
      //  tinderCard.getLoggedInUserName(name: firstNametextLable)
        usersChildRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")

            } else {
                print("The names of female users that the current logged in user swipped are being SAVED")
             //   print("The female name swipped by the logged in user is \(self.femaleName)")
                
            }
        }

    }
    func initiateChat() {
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male")
        print("INITIATE CHAT")
        ref.observe(.childAdded, with: { (snapshot) in
//            print("Users in Female swipped Male database are::\(snapshot) ")
            for name in snapshot.children {
//                self.femaleNames.append((name as AnyObject).key)
                let childSnap = name as! DataSnapshot
//                let key = childSnap.key
                for maleIds in childSnap.children {
       
//                    self.namesSwippedByFemales.append((maleIds as AnyObject).key)
                    
                    if(self.userID == (maleIds as AnyObject).key){
                        
                            self.checkMatch(FemaleId: snapshot.key, FemaleName: childSnap.key)
                        
                       // break;
                    }
                    
                }
            }
        })
    }
   
    func checkMatch(FemaleId: String,FemaleName: String) {
        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female").child(userID!)
     
        ref2.observe(.childAdded) { (snapshot) in
        
            for femaleId in snapshot.children {
//                if snapshot.key == self.firstNametextLable {

                    if (femaleId as AnyObject).key == FemaleId {
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child(FemaleId)
                        ref.observeSingleEvent(of: .value) { (snap) in
                            let snapshotValue = snap.value as! NSDictionary
                            let profilePicURl = snapshotValue["Profile Pic "]
                            self.matchFound(FemaleId: FemaleId, FemaleName: FemaleName,pic: profilePicURl as! String)
                        }
                }
            }
        }
    }
    
    var female_Name : String = ""
    var femaleId : String = ""
    
    func matchFound(FemaleId: String,FemaleName: String, pic: String) {
     
        messages.profilePicURL.append(pic)
        messages.IDS.append(FemaleId)
        messages.finalMatch.append(FemaleName)
        messages.femaleName = FemaleName
        messages.femaleId = FemaleId
        messages.imageURL = pic
        
        notification.name = FemaleName
        notification.id = FemaleId
        notification.firstNametextLable = firstNametextLable

        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(FemaleId)
        badgeCountRef.updateChildValues(["Badge ": 1])
        badgeCountRef.observe(.value) { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            if let badgeAdded = snapshotValue!["Badge added "] as? String {
            }else{
                self.messages.badgeCount = self.messages.badgeCount + 1
                self.dropMenuButton.badge = self.messages.badgeCount
                self.matches.badge = self.messages.badgeCount
                print("BADGE COUNT IS \(self.messages.badgeCount)")

                if self.messages.badgeCount == 1  {
                    self.messages.oneMatch_Name = FemaleName
                    self.messages.profilePic = pic
                    self.notification.sendNotification(title: "Match found💖", subtitle: "You have a new match", body: "You have been matched with \(FemaleName)", badge: 1, delayInterval: 1)
                    
                    self.performSegue(withIdentifier: "PopUpMatch", sender: self)


                }else{
                    self.notification.sendNotification(title: "Multiple Matches found", subtitle: "Check out your matches page.", body: "", badge: 1, delayInterval: 1)
                }

//                self.notification.sendNotification(title: "Match found💖", subtitle: "You have a new match", body: "You have been matched with \(FemaleName)", badge: 1, delayInterval: 1)
                
            }
        }
            
        showMessageBadge(FemaleID: FemaleId, FemaleName: FemaleName)
        presentVC(FemaleID: FemaleId, FemaleName: FemaleName)
    }

    func showMessageBadge(FemaleID: String,FemaleName: String){

        
                let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(FemaleID).child(FemaleName).child("Messages")
             
                badgeCountRef.observe(.childAdded) { (snap) in
                    if let snapshotValue = snap.value as? NSDictionary {
                    if let message = snapshotValue["ReceivedMessage "] as? String {
                         let messageRead = snapshotValue["Message Read "] as! String
                            if messageRead == "False" {
                                self.messages.badgeCount = self.messages.badgeCount + 1
                                self.messages.messageCount = self.messages.messageCount + 1
                                self.dropMenuButton.badge = self.messages.badgeCount
                                self.matches.badge = self.messages.messageCount
                                
                                
                        }
                        
                    }
            }
        }
    }

    
    var menuShowing = false
    @IBAction func dropMenu(_ sender: Any) {
        
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
    
    
    func presentVC(FemaleID: String,FemaleName: String){
        let notificationPressed = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(FemaleID)
        notificationPressed.observe(.value) { (snap) in
            let snapValue = snap.value as! NSDictionary
            if let notifyPressed = snapValue["Pressed "] as? String {
                if notifyPressed == "True" {
                    print("NOTIFY PRESSED \(notifyPressed) from \(FemaleName)")
                    self.NAME.Id = FemaleID
                    self.NAME.usernames = FemaleName
                    self.performSegue(withIdentifier: "goToChatsDirectly", sender: self)
                    notificationPressed.updateChildValues(["Pressed ": "False"])
                }
            }
            
        }
        
    }
    
    func checkPotentialMatches(){

        let ref = Database.database().reference().child("users").child("Female")
        ref.observe(.childAdded) { (snapshot) in
            let ref2 = ref.child(snapshot.key)
            
            ref2.observe(.value, with: { (snap) in
                let snapValue = snap.value as! NSDictionary
                
                
                if (snapValue["Description "] as? String) != nil{
                    self.potentialMatches.count = self.potentialMatches.count + 1
                }
            })
        }
    }
    
    @IBAction func PotenialMatchesButton(_ sender: Any) {
        

        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child(userID!)
        ref.observe(.value) { (snapshot) in
            let snapValue = snapshot.value as! NSDictionary
            if let description = snapValue["Description "] as? String  {

                print("DESCRIPTION IS \(description)")
                if self.potentialMatches.count == 0 {
                    self.alertTheUser(title: "Sorry but we are still finding users that share your interests ", message: "Keep swiping so that we can judge your interests better. ")
                }else{
                    self.performSegue(withIdentifier: "PotentialMatch", sender: self)
                }
            }else{
                self.alertUserProfile(title: "Write a description about yourself.", message: "Check out your profile to write a description about yourself. This will help us find some potential matches for you.")
                UIView.animate(withDuration: 1, animations: {
                    self.YourProfileButtonView.backgroundColor = UIColor.flatYellowColorDark()
                    self.YourProfileButtonView.translatesAutoresizingMaskIntoConstraints = false
                    self.YourProfileButtonView.layer.masksToBounds = true
                    self.YourProfileButtonView.layer.cornerRadius = 6
                })
            }
        }
    }
    func alertUserProfile(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                self.YourProfileButtonView.backgroundColor = UIColor.clear
                
            })
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var finalMatch =  [String]()

        if segue.identifier == "goToMatches" {
            let destinationVC = segue.destination as! UserTableViewController

            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.femaleNames = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.age = age
            destinationVC.gender = "Male"
            
        }
        
        if segue.identifier == "goToSettings" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = "Male"

        }
        
        if segue.identifier == "goToChatsDirectly" {
            let destinationVC = segue.destination as! ChatLogTableViewController
            print("NOTIFY SENDER \(notification.name) \(notification.id)")

            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.femaleNames = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.age = age
            destinationVC.gender = "Male"
            destinationVC.femaleId = NAME.Id!
            destinationVC.femaleName = NAME.usernames!
        }
        
        if segue.identifier == "PopUpMatch" {
            let destinationVC = segue.destination as! PopNewMatchViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.femaleNames = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.Name = messages.oneMatch_Name
            destinationVC.pic = messages.profilePic
            destinationVC.gender = "Male"
            destinationVC.age = age
            destinationVC.gender = "Male"
        }
        
        if segue.identifier == "ProfileUpdate"{
            let destinationVC = segue.destination as! ProfileUpdateViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = "Male"

        }
        
        if segue.identifier == "PotentialMatch" {
            let destinationVC = segue.destination as! PotentialMatchVC
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = "Female"
            destinationVC.currentUserGender = "Male"
            destinationVC.checkFemaleSwipes = "Female Swipped Male"
            destinationVC.checkMaleSwipes = "Male Swipped Female"
        }
        
    }
  
    
    @IBAction func matchesButton(_ sender: Any) {
        if messages.finalMatch.count>0{
            performSegue(withIdentifier: "goToMatches", sender: self)
        }else{
            alertTheUser(title: "You have no matches. Keep swiping.🥰", message: "")
        }
    }
    
    func alertMatchToUser(FemalePic : String, FemaleName: String,title: String, message: String){
        
      performSegue(withIdentifier: "PopUpMatch", sender: self)
        
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

extension SearchPartnerViewController : TinderCardDelegate{
    
    // action called when the card goes to the left.
    func cardGoesLeft(card: TinderCard) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: TinderCard) {
        removeObjectAndAddNewValues()
    }
    func currentCardStatus(card: TinderCard, distance: CGFloat) {
        
        if distance == 0 {
            emojiView.rateValue =  2.5
        }else{
            let value = Float(min(fabs(distance/100), 1.0) * 5)
            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
            emojiView.rateValue =  sorted
        }
        
        
    }
}


