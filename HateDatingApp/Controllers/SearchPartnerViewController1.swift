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
    @IBOutlet weak var ProfilePicImage: UIImageView!
    @IBOutlet weak var extraView: UIView!

    var user = User()
    var age : Int!
    var CardDistY : CGFloat!
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
    var CurrentUserGender : String = ""
    var gender : String = ""
    
//    var count : Int = 0
    var IDsMatched = [String]()
    var receiverIds = [String]()
    var Names = [String]()
    var namesSwippedByFemales = [String]()
    var namesSwippedByMales = [String]()
    var NamesMatched = [String]()
    var notification = NotificationPublisher()
    var badge : Int!
    var NAME = names()
    let potentialMatches = potentialMatchedUsers()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        notification.notification()
        viewActions?.alpha = 0
        buttonUndo?.alpha = 0
        fetchImagesAndPostThem()
        maleSwippedFemale(values: ["Name " : self.firstNametextLable] as [String : AnyObject])
        initiateChat()
        messages.userID = userID
        messages.currentUserName = firstNametextLable
//        messages.gender = CurrentUserGender


        dropMenuButton?.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dropMenuButton?.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        matches?.setImage(UIImage(named: "Matches2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        matches?.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
        
        print("CURRENT USERS GENDER IS \(CurrentUserGender)")
        
        var USER = Auth.auth().currentUser;
        if USER!.isEmailVerified == false {
            USER?.sendEmailVerification(completion: { (error) in
                if error == nil {
                    print("SENT VERIFICATION TO \(String(describing: USER?.email))")
                    self.alertTheUser(title: "Verification email sent", message: "Please verify your email.")
                }
            })
        }
        checkPotentialMatches()
        ProfilePicImage.layer.cornerRadius = ProfilePicImage.frame.width/2.0
        ProfilePicImage.translatesAutoresizingMaskIntoConstraints = false
//        ProfilePicImage.layer.shadowRadius = 6
//        ProfilePicImage.layer.shadowOpacity = 1
//        ProfilePicImage.layer.shadowColor = UIColor.blue.cgColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        //loadCardValues()
    }
    
    
    
    func getLoggedInUserInfo() -> String{
        return user.name
    }
    
    
    func getUsernamePic(){
        let ref = Database.database().reference().child("users").child(CurrentUserGender).child(userID!)
        ref.observe(.value) { (snap) in
            if let snapValue = snap.value as? NSDictionary {
            if let profilePic = snapValue["Profile Pic "] as? String {
                if let url = URL(string: profilePic){
                    
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("Failed while fetching images : \(error?.localizedDescription)")
                        }else {
                            DispatchQueue.main.async {
                                self.ProfilePicImage?.image = UIImage(data: data!)
                            }
                        }
                    }).resume()
                }
            }
        }
    }
}
    
    
    
//    @objc func animateEmojiView(timer : Timer){
//        let sender = timer.userInfo as! EmojiRateView
//        emojiView.rateValue =  emojiView.rateValue + 0.2
//        if sender.rateValue >= 5 {
//            timer.invalidate()
//            emojiView.rateValue = 2.5
//        }
//    }

    
    
    func loadCardValues(pics: [String], names: [String],receiverIds: [String]) {
      
      
        if pics.count > 0 {
            
            let capCount = (pics.count > MAX_BUFFER_SIZE1) ? MAX_BUFFER_SIZE1 : pics.count
            for (i,pic) in pics.enumerated() {
                
                
                let newCard = self.createTinderCard(at: i,pic: pic,name: names[i],Id: receiverIds[i])

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
        //Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.animateEmojiView), userInfo: emojiView, repeats: true)
    }
    

    func createTinderCard(at index: Int , pic :String, name: String, Id: String) -> TinderCard {
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic, name: name,Id : Id)
        card.delegate = self
        user.name = name
        user.id = Id
        print("NAMEEEES \(name)")

        return card
    }
    let showInfo = Show_Info()

    func removeObjectAndAddNewValues() {
//        emojiView.rateValue =  2.5
        UIView.animate(withDuration: 0.5) {
            self.buttonUndo.alpha = 0
        }
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
//        NAME.count = currentLoadedCardsArray.count
        checkCardStack(count: currentLoadedCardsArray.count)
        showInfo.currentIndex = currentIndex
        
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
    
    
    let anime = animations()
    func checkCardStack(count: Int){
        anime.remove = true
//        createPulse()
        if count == 0 {
            anime.remove = false
            getUsernamePic()
            createPulse()
            print("CURRENT LOADED COUNT IS \(count)")
        }
    }
    
    var pulseLayers = [CAShapeLayer]()
    func createPulse(){
        if anime.remove == false {
            extraView.isHidden = false

        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
                pulseLayer.lineWidth = 2.0
            
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.strokeColor = UIColor.green.cgColor
            pulseLayer.lineCap = kCALineCapRound
            pulseLayer.position = CGPoint(x: extraView.center.x, y: extraView.center.y)
            extraView.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.pulseAnimation(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                self.pulseAnimation(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                    self.pulseAnimation(index: 2)
                }
            }
        }
            
    }else{
            print("REMOVING ALL ANIMES")
            extraView.isHidden = true
            
        }
    }
    
    
    func pulseAnimation(index: Int){
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnime = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnime.duration = 2.0
        opacityAnime.fromValue = 0.9
        opacityAnime.toValue = 0.0
        opacityAnime.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        opacityAnime.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnime, forKey: "opacity")
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
    
    @IBAction func show_Info(_ sender: Any) {
        
        showInfo.gender = gender
        let j = showInfo.currentIndex
        if currentLoadedCardsArray.count > 0 {
            showInfo.Id = showInfo.IDs[j]
            performSegue(withIdentifier: "ShowInfo", sender: self)
        }
//        }
    }
    
    @IBAction func disLikeButtonAction(_ sender: Any) {
        let card = currentLoadedCardsArray.first
        card?.leftClickAction()
        checkCardStack(count: currentLoadedCardsArray.count)
    }
 
    
    @IBAction func LikeButtonAction(_ sender: Any) {
        
        let card = currentLoadedCardsArray.first
        card?.rightClickAction()
        checkCardStack(count: currentLoadedCardsArray.count)

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
        anime.remove = true
        createPulse()
        
        currentIndex =  currentIndex - 1
        print("Current index is \(currentIndex)")
        showInfo.currentIndex = currentIndex

        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE1 {
            
            let lastCard = currentLoadedCardsArray.last
            lastCard?.rollBackCard()
            currentLoadedCardsArray.removeLast()
        }

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
        let ref = Firebase.Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(gender)
        
        ref.observe(.value) { (snap) in
//            print("SNAP \(snap.childrenCount)")
            
            let count = Int(snap.childrenCount)
            //ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
            //Therefore we user observe which does the opposite.
            ref.observe(.childAdded, with: { (snapshot) in
//                self.messages.receiverID = snapshot.key
                let snapshotValue = snapshot.value as! NSDictionary

                let pic = snapshotValue["Profile Pic "] as? String
                let username = snapshotValue["Name "] as? String
                let receiverId = snapshotValue["UserId "] as? String
                self.receiverIds.append(receiverId!)
                self.profilePic.append(pic!)
                self.name.append(username!)
                
                self.showInfo.IDs = self.receiverIds
                self.messages.receiverID = receiverId!
                if self.profilePic.count == count {
                    self.loadCardValues(pics: self.profilePic, names: self.name, receiverIds: self.receiverIds)
                }
            })
        }
    }
    
    
    func maleSwippedFemale(values: [String: AnyObject]) {
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
        if CurrentUserGender == "Male" {
            let usersChildRef = ref.child("users").child("MSF").child(userID!)
            usersChildRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
                    
                } else {
                    print("The names of female users that the current logged in user swipped are being SAVED")
                    //   print("The female name swipped by the logged in user is \(self.Name)")
                    
                }
            }

        }else{
            let usersChildRef = ref.child("users").child("FSM").child(userID!)
            usersChildRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
                    
                } else {
                    print("The names of female users that the current logged in user swipped are being SAVED")
                    //   print("The female name swipped by the logged in user is \(self.Name)")
                    
                }
            }

        }
       // TinderCard.getLoggedInUserName()
      //  tinderCard.getLoggedInUserName(name: firstNametextLable)
        
    }
    
    
    func initiateChat() {
        if CurrentUserGender == "Male" {

        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male")
        print("INITIATE CHAT")
        ref.observe(.childAdded, with: { (snapshot) in
            print("Users in Female swipped Male database are::\(snapshot) ")
            for name in snapshot.children {
//                self.Names.append((name as AnyObject).key)
                let childSnap = name as! DataSnapshot
//                let key = childSnap.key
                for maleIds in childSnap.children {
       
//                    self.namesSwippedByFemales.append((maleIds as AnyObject).key)
                    
                    if(self.userID == (maleIds as AnyObject).key){
                        
                            self.checkMatch(ID: snapshot.key, Name: childSnap.key)
                        
                       // break;
                    }
                    
                }
            }
        })
        }else{
            ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female")
            print("INITIATE CHAT")
            ref.observe(.childAdded, with: { (snapshot) in
                //            print("Users in Female swipped Male database are::\(snapshot) ")
                for name in snapshot.children {
                    //                self.Names.append((name as AnyObject).key)
                    let childSnap = name as! DataSnapshot
                    //                let key = childSnap.key
                    for maleIds in childSnap.children {
                        
                        //                    self.namesSwippedByFemales.append((maleIds as AnyObject).key)
                        
                        if(self.userID == (maleIds as AnyObject).key){
                            
                            self.checkMatch(ID: snapshot.key, Name: childSnap.key)
                            
                            // break;
                        }
                        
                    }
                }
            })
        }
    }
   
    func checkMatch(ID: String,Name: String) {
        if CurrentUserGender == "Male" {
            print("MATCHED IDDDD IS \(CurrentUserGender)")
        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female").child(userID!)
     
        ref2.observe(.childAdded) { (snapshot) in
        
            for id in snapshot.children {
//                if snapshot.key == self.firstNametextLable {
                print("MATCHED IDSSS AREEE \(id)")

                    if (id as AnyObject).key == ID {
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(self.gender).child(ID)
                        ref.observeSingleEvent(of: .value) { (snap) in
                            if let snapshotValue = snap.value as? NSDictionary {
                                let profilePicURl = snapshotValue["Profile Pic "]
                                self.matchFound(ID: ID, Name: Name,pic: profilePicURl as! String)
                            }
                            
                        }
                }
            }
        }
    }else{
            ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male").child(userID!)
            
            ref2.observe(.childAdded) { (snapshot) in
                
                for Id in snapshot.children {
                    //                if snapshot.key == self.firstNametextLable {
                    
                    if (Id as AnyObject).key == ID {
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(self.gender).child(ID)
                        ref.observeSingleEvent(of: .value) { (snap) in
                            if let snapshotValue = snap.value as? NSDictionary {
                                let profilePicURl = snapshotValue["Profile Pic "]
                                self.matchFound(ID: ID, Name: Name,pic: profilePicURl as! String)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var female_Name : String = ""
    var ID : String = ""
    
    func matchFound(ID: String,Name: String, pic: String) {
     
        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(CurrentUserGender).child(userID!).child(firstNametextLable).child(ID).child(Name)
        inMessageVC.updateChildValues(["In Message VC ": false])
        print("MATHCEDDD PEOPLE ARE \(messages.finalMatch)")
        messages.profilePicURL.append(pic)
        messages.IDS.append(ID)
        messages.finalMatch.append(Name)
        messages.Name = Name
        messages.ID = ID
        messages.imageUrl = pic
        
        notification.name = Name
        notification.id = ID
        notification.firstNametextLable = firstNametextLable

        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(CurrentUserGender).child(userID!).child(firstNametextLable).child(ID)
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
                    self.messages.oneMatch_Name = Name
                    self.messages.profilePic = pic
                    self.notification.sendNotification(title: "Match found💖", subtitle: "You have a new match", body: "You have been matched with \(Name)", badge: 1, delayInterval: 1)
                    
                    self.performSegue(withIdentifier: "PopUpMatch", sender: self)


                }else{
                    self.notification.sendNotification(title: "Multiple Matches found", subtitle: "Check out your matches page.", body: "", badge: 1, delayInterval: 1)
                }

//                self.notification.sendNotification(title: "Match found💖", subtitle: "You have a new match", body: "You have been matched with \(Name)", badge: 1, delayInterval: 1)
                
            }
        }
            
        showMessageBadge(ID: ID, Name: Name)
        presentVC(ID: ID, Name: Name)
    }

    func showMessageBadge(ID: String,Name: String){

        
                let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(CurrentUserGender).child(userID!).child(firstNametextLable).child(ID).child(Name).child("Messages")
             
                badgeCountRef.observe(.childAdded) { (snap) in
                    if let snapshotValue = snap.value as? NSDictionary {
                    if let message = snapshotValue["text "] as? String {
                        if let messageRead = snapshotValue["Message Read "] as? Bool {
                            if messageRead == false {
                                self.messages.badgeCount = self.messages.badgeCount + 1
                                self.messages.messageCount = self.messages.messageCount + 1
                                self.dropMenuButton.badge = self.messages.badgeCount
                                self.matches.badge = self.messages.messageCount
                            }
                        }
                    }
                }
            }
        }
    
    func presentVC(ID: String,Name: String){
        print("NOTIFICATION FOR \(userID!) , \(firstNametextLable)")
        let notificationPressed = Database.database().reference().child("users").child("Match").child(CurrentUserGender).child(userID!).child(firstNametextLable).child(ID)
        notificationPressed.observe(.value) { (snap) in
            if let snapValue = snap.value as? NSDictionary {
            if let notifyPressed = snapValue["Pressed "] as? Bool {
                if notifyPressed == true {
                    print("NOTIFY PRESSED \(notifyPressed) from \(Name)")
                    self.NAME.Id = ID
                    self.NAME.usernames = Name
                    notificationPressed.updateChildValues(["Pressed ": false])
                    self.performSegue(withIdentifier: "goToChatDirectly", sender: self)
                }
            }
        }
        }
        
    }
    
    var menuShowing = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            trailingConstraint.constant = 218
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        menuShowing = !menuShowing
    }
    
    
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
    
 
    
    func checkPotentialMatches(){

        let ref = Database.database().reference().child("users").child(gender)
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
        

        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(CurrentUserGender).child(userID!)
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
            destinationVC.MatchedNames = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.age = age
            destinationVC.currentUsersGender = CurrentUserGender
            destinationVC.gender = gender
        }
        
        if segue.identifier == "goToSettings" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.currentUserGender = CurrentUserGender
            destinationVC.gender = gender
            
        }
        
        if segue.identifier == "goToChatsDirectly" {
            let destinationVC = segue.destination as! ChatLogController
            print("NOTIFY SENDER \(NAME.usernames!) \(NAME.Id!)")

            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.names = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.age = age
            destinationVC.currentUsersGender = CurrentUserGender
            destinationVC.gender = gender
            destinationVC.id = NAME.Id!
            destinationVC.name = NAME.usernames!
        }
        if segue.identifier == "goToChatDirectly" {
            let destinationVC = segue.destination as! UserTableViewController
            print("NOTIFY SENDER \(NAME.usernames!) \(NAME.Id!)")
            
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.MatchedNames = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.age = age
            destinationVC.currentUsersGender = CurrentUserGender
            destinationVC.gender = gender
            destinationVC.ID = NAME.Id!
            destinationVC.NAME = NAME.usernames!
            destinationVC.newMessageReceived = true
        }
        if segue.identifier == "PopUpMatch" {
            let destinationVC = segue.destination as! PopNewMatchViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.MatchedNames = messages.finalMatch
            destinationVC.IDs = messages.IDS
            destinationVC.profilePicURL = messages.profilePicURL
            destinationVC.Name = messages.oneMatch_Name
            destinationVC.pic = messages.profilePic
            destinationVC.currentUserGender = CurrentUserGender
            destinationVC.age = age
            destinationVC.gender = gender
        }
        
        if segue.identifier == "ProfileUpdate"{
            let destinationVC = segue.destination as! ProfileUpdateViewController
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.CurrentUserGender = CurrentUserGender
            destinationVC.gender = gender
        }
        
        if segue.identifier == "PotentialMatch" {
            let destinationVC = segue.destination as! PotentialMatchVC
            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.gender = gender
            destinationVC.currentUserGender = CurrentUserGender
            destinationVC.checkFemaleSwipes = "Female Swipped Male"
            destinationVC.checkMaleSwipes = "Male Swipped Female"
        }
        
        if segue.identifier == "ShowInfo" {
            let destinationVC = segue.destination as! ShowDescriptionViewController
            destinationVC.gender =  gender
            destinationVC.id = showInfo.Id

        }
        
    }
  
    
    @IBAction func matchesButton(_ sender: Any) {
        if messages.finalMatch.count>0{
            performSegue(withIdentifier: "goToMatches", sender: self)
        }else{
            alertTheUser(title: "You have no matches. Keep swiping.🥰", message: "")
        }
    }
    
    func alertMatchToUser(FemalePic : String, Name: String,title: String, message: String){
        
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
//            emojiView.rateValue =  2.5
        }else{
            let value = Float(min(fabs(distance/100), 1.0) * 5)
            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
//            emojiView.rateValue =  sorted
        }
        
        
    }
}


