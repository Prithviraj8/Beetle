////
////  ViewController.swift
////  testingTinderSwipe
////
////  Created by Nicky on 11/16/17.
////  Copyright © 2017 Nicky. All rights reserved.
////
//
//let  MAX_BUFFER_SIZE = 3;
//let  SEPERATOR_DISTANCE = 8;
//let  TOPYAXIS = 75;
//
//import UIKit
//import Firebase
//import FirebaseStorage
//
//class FemaleSearchPartnerViewController: UIViewController {
//    
//    
//    @IBOutlet weak var emojiView: EmojiRateView!
//    @IBOutlet weak var viewTinderBackGround: UIView!
//    @IBOutlet weak var buttonUndo: UIButton!
//    @IBOutlet weak var viewActions: UIView!
//    @IBOutlet weak var dropMenuView: UIView!
//    @IBOutlet weak var dropMenuButton: BadgeButton!
//    @IBOutlet weak var matches: BadgeButton!
//    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var YourProfileButtonView: UIView!
//    @IBOutlet weak var ProfilePicImage: UIImageView!
//    @IBOutlet weak var extraView: UIView!
//    
//    
//    var IDs = [String]()
//    var profilePicOfLoggedInUser : String = ""
////    var ID : String = ""
//    var age : Int!
//    var userID = Auth.auth().currentUser?.uid
//    var maleNamesMatched = [String]()
//    var femaleNames = [String]()
//    var namesSwippedByFemales = [String]()
//    var currentIndex = 0
//    var handler : Handler!
//    var ref : DatabaseReference!
//    var ref2 : DatabaseReference!
//    var tinderCard : TinderCardFemale!
//    var profilePic = [String]()
//    var name = [String]()
//    var firstNametextLable : String!
//    var namesSwippedByMales = [String]()
//    var maleName : String = ""
//    var maleId : String = ""
//    var messages = message()
//    var receiverIds = [String]()
//    
//    var currentLoadedCardsArray = [TinderCardFemale]()
//    var allCardsArray = [TinderCardFemale]()
//    var cardArray = [UIView]()
//    var notification = NotificationPublisher()
//    var count : Int = 0
//    var maleNames = [String]()
//    var user = User()
//    let potentialMatches = potentialMatchedUsers()
//    let showInfo = Show_Info()
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewActions.alpha = 0
//        buttonUndo.alpha = 0
//        fetchImagesAndPostThem()
//        femaleSwippedMale(values: ["Name ": firstNametextLable as AnyObject])
//        print("FIRST NAME is\(String(describing: firstNametextLable)) & USER ID IS \(String(describing: userID))")
//        initiateChat()
//       
//        messages.userID = userID
//        messages.currentUserName = firstNametextLable
//        messages.gender = "Female"
//        dropMenuButton.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        dropMenuButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
//        matches.setImage(UIImage(named: "Matches2")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        matches.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 10)
//        
//        let USER = Auth.auth().currentUser;
//        if USER!.isEmailVerified == false {
//            USER?.sendEmailVerification(completion: { (error) in
//                if error == nil {
//                    print("SENT VERIFICATION TO \(String(describing: USER?.email))")
//                    self.alertTheUser(title: "Verification email sent", message: "Please verify your email.")
//                }
//            })
//        }
//    
//        checkPotentialMatches()
//        ProfilePicImage.layer.cornerRadius = ProfilePicImage.frame.width/2.0
//        
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        view.layoutIfNeeded()
//        //loadCardValues()
//    }
//    
//    @IBAction func logoutPressed(_ sender: Any) {
//        
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil )
//        let initialVC = storyBoard.instantiateViewController(withIdentifier: "ViewController")
//        self.present(initialVC, animated: true, completion: nil)
//        
//    }
//    
//    
//    func getUsernamePic(){
//        let ref = Database.database().reference().child("users").child("Female").child(userID!)
//        ref.observe(.value) { (snap) in
//            if let snapValue = snap.value as? NSDictionary {
//                if let profilePic = snapValue["Profile Pic "] as? String {
//                    if let url = URL(string: profilePic){
//                        
//                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//                            if error != nil {
//                                print("Failed while fetching images : \(error?.localizedDescription)")
//                            }else {
//                                DispatchQueue.main.async {
//                                    self.ProfilePicImage?.image = UIImage(data: data!)
//                                }
//                            }
//                        }).resume()
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    @objc func animateEmojiView(timer : Timer){
//        let sender = timer.userInfo as! EmojiRateView
//        emojiView.rateValue =  emojiView.rateValue + 0.2
//        if sender.rateValue >= 5 {
//            timer.invalidate()
//            emojiView.rateValue = 2.5
//        }
//    }
//
//    func loadCardValues(pics: [String], names: [String], receiverIds: [String]) {
//        
//       
//        if pics.count > 0 {
//            
//            let capCount = (pics.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : pics.count
//            
//            
//            
//            
//            for (i,pic) in pics.enumerated() {
//                //   for(i,name) in names.enumerated() {
//                
//                //            for i in 1...pics.count && && i < names.count {
//                let newCard = createTinderCard(at: i,pic: pic,name: names[i],Id: receiverIds[i])
//                
//                //Checking value array.
//                // print("The PIC IS ::  \(pic)")
//                print("\(i): '\(pic)'")
//                
//                allCardsArray.append(newCard)
//                //                currentLoadedCardsArray.append(newCard)
//                
//                //                Card.addSubview(allCardsArray[i])
//                
//                
//                if i < capCount {
//                    currentLoadedCardsArray.append(newCard)
//                }
//                
//                //}
//            }
//           
//            
//            for (i,_) in currentLoadedCardsArray.enumerated() {
//                if i > 0 {
//                    viewTinderBackGround.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
//                }else {
//                    viewTinderBackGround.addSubview(currentLoadedCardsArray[i])
//                }
//            }
//            animateCardAfterSwiping()
//            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
//        }
//        print("THE PROFILE PIC ARRAY IS EMPTY!!!!!!!")
//        
//    }
//    
//    @objc func loadInitialDummyAnimation() {
//        
//        let dummyCard = currentLoadedCardsArray.first;
//        dummyCard?.shakeAnimationCard()
//        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveLinear, animations: {
//            self.viewActions.alpha = 1.0
//        }, completion: nil)
//        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.animateEmojiView), userInfo: emojiView, repeats: true)
//    }
//    
//   
//    func createTinderCard(at index: Int , pic :String, name: String,Id: String) -> TinderCardFemale {
//        let card = TinderCardFemale(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic, name: name,Id: Id)
//        user.name = name
//        user.id = Id
//        
//        card.delegate = self as! TinderCardFemaleDelegate
//        return card
//    }
//    
//    func removeObjectAndAddNewValues() {
//        
//        emojiView.rateValue =  2.5
//        UIView.animate(withDuration: 0.5) {
//            self.buttonUndo.alpha = 0
//        }
//        currentLoadedCardsArray.remove(at: 0)
//        currentIndex = currentIndex + 1
//        
//        checkCardStack(count: currentLoadedCardsArray.count)
//        showInfo.currentIndex = currentIndex
//
//        
//        Timer.scheduledTimer(timeInterval: 1.01, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)
//        
//        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
//            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
//            var frame = card.frame
//            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
//            card.frame = frame
//            currentLoadedCardsArray.append(card)
//            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE - 2])
//        }
//        print(currentIndex)
//        animateCardAfterSwiping()
//    }
//    
//    
//    
//    let anime = animations()
//    func checkCardStack(count: Int){
//        anime.remove = true
//        //        createPulse()
//        if count == 0 {
//            anime.remove = false
//            getUsernamePic()
//            createPulse()
//            print("CURRENT LOADED COUNT IS \(count)")
//        }
//    }
//    
//    var pulseLayers = [CAShapeLayer]()
//    func createPulse(){
//        if anime.remove == false {
//            extraView.isHidden = false
//            
//            for _ in 0...2 {
//                let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
//                let pulseLayer = CAShapeLayer()
//                pulseLayer.path = circularPath.cgPath
//                pulseLayer.lineWidth = 2.0
//                
//                pulseLayer.fillColor = UIColor.clear.cgColor
//                pulseLayer.strokeColor = UIColor.green.cgColor
//                pulseLayer.lineCap = kCALineCapRound
//                pulseLayer.position = CGPoint(x: extraView.center.x, y: extraView.center.y)
//                extraView.layer.addSublayer(pulseLayer)
//                pulseLayers.append(pulseLayer)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
//                self.pulseAnimation(index: 0)
//                DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
//                    self.pulseAnimation(index: 1)
//                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
//                        self.pulseAnimation(index: 2)
//                    }
//                }
//            }
//            
//        }else{
//            print("REMOVING ALL ANIMES")
//            extraView.isHidden = true
//            
//        }
//    }
//    func pulseAnimation(index: Int){
//        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
//        scaleAnimation.duration = 2.0
//        scaleAnimation.fromValue = 0.0
//        scaleAnimation.toValue = 0.9
//        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        scaleAnimation.repeatCount = .greatestFiniteMagnitude
//        pulseLayers[index].add(scaleAnimation, forKey: "scale")
//        
//        let opacityAnime = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
//        opacityAnime.duration = 2.0
//        opacityAnime.fromValue = 0.9
//        opacityAnime.toValue = 0.0
//        opacityAnime.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        opacityAnime.repeatCount = .greatestFiniteMagnitude
//        pulseLayers[index].add(opacityAnime, forKey: "opacity")
//    }
//    
//    
//    
//    func animateCardAfterSwiping() {
//        
//        for (i,card) in currentLoadedCardsArray.enumerated() {
//            UIView.animate(withDuration: 0.5, animations: {
//                if i == 0 {
//                    card.isUserInteractionEnabled = true
//                }
//                var frame = card.frame
//                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
//                card.frame = frame
//            })
//        }
//    }
//    
//    @IBAction func show_Info(_ sender: Any) {
//        showInfo.gender = "Male"
//        let j = showInfo.currentIndex
//        print("J ISS \(j) && \(showInfo.IDs.count)")
//        if currentLoadedCardsArray.count > 0{
//            showInfo.Id = showInfo.IDs[j]
//            performSegue(withIdentifier: "ShowInfo", sender: self)
//        }
//        
//        
//    }
//    
//    @IBAction func disLikeButtonAction(_ sender: Any) {
//        let card = currentLoadedCardsArray.first
//        card?.leftClickAction()
//        checkCardStack(count: currentLoadedCardsArray.count)
//        
//    }
//    
//    
//    @IBAction func LikeButtonAction(_ sender: Any) {
//        
//        let card = currentLoadedCardsArray.first
//        card?.rightClickAction()
//        checkCardStack(count: currentLoadedCardsArray.count)
//
//        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male").child(userID!)
//        
//        let ref = ref2.child(firstNametextLable).child(user.id).child(user.name)
//        ref.observe(.value, with: { (snap) in
//            if let value = snap.value as? NSDictionary {
//                if let added = value["Added "] as? String {
//                    if added != "True" {
//                        self.initiateChat()
//                    }
//                }
//            }
//        })
//        
//    }
//    
//    @IBAction func undoButtonAction(_ sender: Any) {
//        anime.remove = true
//        createPulse()
//
//        currentIndex =  currentIndex - 1
//        showInfo.currentIndex = currentIndex
//
//        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE {
//            
//            
//            let lastCard = currentLoadedCardsArray.last
//            lastCard?.rollBackCard()
//            currentLoadedCardsArray.removeLast()
//        }
//        print("Current index is \(currentIndex)")
//        let undoCard = allCardsArray[currentIndex]
//        undoCard.layer.removeAllAnimations()
//        viewTinderBackGround.addSubview(undoCard)
//        undoCard.makeUndoAction()
//        currentLoadedCardsArray.insert(undoCard, at: 0)
//        animateCardAfterSwiping()
//        if currentIndex == 0 {
//            UIView.animate(withDuration: 0.5) {
//                self.buttonUndo.alpha = 0
//            }
//        }
//    }
//    
//    @objc func enableUndoButton(timer: Timer){
//        
//        let cardIntex = timer.userInfo as! Int
//        if (currentIndex == cardIntex) {
//            
//            UIView.animate(withDuration: 0.5) {
//                self.buttonUndo.alpha = 1.0
//            }
//        }
//    }
//    
//    
//    var menuShowing = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        trailingConstraint.constant = 218
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//        menuShowing = !menuShowing
//    }
//    @IBAction func dropMenuPressed(_ sender: Any) {
//        
//        
//        dropMenuView.layer.shadowOpacity = 1
//        dropMenuView.layer.shadowRadius = 6
//        
//        if(menuShowing) {
//            
//            trailingConstraint.constant = 218
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//        }else{
//            trailingConstraint.constant = 0
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//        }
//        
//        menuShowing = !menuShowing
//        
//    }
//    
////Fetching images and other info from firebase Database
//    func fetchImagesAndPostThem() {
//        var ref = Firebase.Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male")
//        
//        ref.observe(.value) { (snap) in
//            print("SNAP \(snap.childrenCount)")
//            
//            let count = Int(snap.childrenCount)
//           
//            //   ref.observeSingleEvent(of: .childAdded) { (snapshot) in
//            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
//            //Therefore we user observe which does the opposite.
//            ref.observe(.childAdded, with: { (snapshot) in
//                
//                
//                let snapshotValue = snapshot.value as! NSDictionary
//                
//                let pic = snapshotValue["Profile Pic "] as? String
//                let NAME = snapshotValue["Name "] as? String
//                let receiverId = snapshotValue["UserId "] as? String
//                self.receiverIds.append(receiverId!)
//                self.messages.receiverID = receiverId
//                self.showInfo.IDs = self.receiverIds
//                print("MATCHED NAMES ARE \(NAME!)")
//                self.profilePic.append(pic!)
//                self.name.append(NAME!)
//                
//  
//                if self.profilePic.count == count {
//                    self.loadCardValues(pics: self.profilePic, names: self.name,receiverIds: self.receiverIds)
//                }
//            })
//            
//            
//        }
//        
//    }
//    func femaleSwippedMale(values: [String: AnyObject]) {
//        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
//        let usersChildRef = ref.child("users").child("FSM").child(userID!)
//      
//        usersChildRef.updateChildValues(values)
//
//    }
//    
//    func initiateChat() {
//        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male Swipped Female")
//        print("INITIATE CHAT")
//        
//        ref.observe(.childAdded, with: { (snapshot) in
//            //            print("Users in Female swipped Male database are::\(snapshot) ")
//            
//            for name in snapshot.children {
//                self.maleNames.append((name as AnyObject).key)
//                let childSnap = name as! DataSnapshot
////                print("The male names are \(self.maleNames)")
////                print("KEYY IS : \(childSnap.key)")
//                for females in childSnap.children {
//                    let snap = females as! DataSnapshot
////                    print("The names of the females that this male-- \(name)  has liked are \(females)")
//                    self.namesSwippedByMales.append((females as AnyObject).key)
//                    
//                    
//                }
//                for names in self.namesSwippedByMales {
////                    print("The names of males being checked are \(names)")
//                    if(self.userID == names){
////                        print("YAYY THE HOT GUY::\(name) LIKES YOU::\(self.firstNametextLable)")
//
//                        self.checkMatch(MaleId: snapshot.key, MaleName: childSnap.key)
//                        break;
//                        
//                    }
//                    
//                    
//                    
//                }
//                
//            }
//        })
//    }
//
//    func checkMatch(MaleId: String,MaleName : String) {
//        ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female Swipped Male").child(userID!)
//        
//
//        ref2.observe(.childAdded) { (snapshot) in
//            for maleId in snapshot.children {
////                if snapshot.key == self.firstNametextLable {
//                if (maleId as AnyObject).key == MaleId {
//                    
//                let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child(MaleId)
//                ref.observeSingleEvent(of: .value) { (snap) in
//                    if let snapshotValue = snap.value as? NSDictionary {
//                        let profilePicURl = snapshotValue["Profile Pic "]
//                        self.matchFound(MaleId: MaleId, MaleName: MaleName, pic: profilePicURl as! String)
//                        }
//                    }
//                    }
////                }
//            }
//        }
//    }
//
//    func matchFound(MaleId: String,MaleName : String,pic: String) {
//        let inMessageVC = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child(userID!).child(firstNametextLable).child(MaleId).child(MaleName)
//        inMessageVC.updateChildValues(["In Message VC ": false])
//        
//        messages.profilePicURL.append(pic)
//        messages.IDS.append(MaleId)
//        messages.finalMatch.append(MaleName)
//        messages.maleName = MaleName
//        messages.maleId = MaleId
//        messages.imageUrl = pic
//        
//        notification.name = MaleName
//        notification.id = MaleId
//        notification.firstNametextLable? = firstNametextLable
//        
//        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(MaleId)
//        badgeCountRef.updateChildValues(["Badge ": 1])
//        badgeCountRef.observe(.value) { (snapshot) in
//            let snapshotValue = snapshot.value as? NSDictionary
//            if  let badgeAdded = snapshotValue!["Badge added "] as? String {
//            }else{
//                self.messages.badgeCount = self.messages.badgeCount + 1
//                self.dropMenuButton.badge = self.messages.badgeCount
//                self.matches.badge = self.messages.badgeCount
//                print("BADGE COUNT IS \(self.messages.badgeCount)")
//
//                if self.messages.badgeCount == 1 {
//                    self.messages.oneMatch_Name = MaleName
//                    self.messages.profilePic = pic
//                    self.notification.sendNotification(title: "Match found", subtitle: "You have a new match", body: "You have been matched with \(MaleName)", badge: 1, delayInterval: 1)
//                    self.performSegue(withIdentifier: "PopUpMatch", sender: self)
//
//                }else{
//                    self.notification.sendNotification(title: "Multiple Matches found", subtitle: "Check out your matches page.", body: "", badge: 1, delayInterval: 1)
//
//                }
//                
//
//            }
//            
//            
//        }
//        showMessageBadge(MaleID: MaleId, MaleName: MaleName)
//        presentVC(MaleID: MaleId, MaleName: MaleName)
//    }
//    func showMessageBadge(MaleID: String,MaleName: String){
//        
//        
//        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(MaleID).child(MaleName).child("Messages")
//        
//        badgeCountRef.observe(.childAdded) { (snap) in
//            let snapshotValue = snap.value as! NSDictionary
//            if let message = snapshotValue["text "] as? String {
//                if let messageRead = snapshotValue["Message Read "] as? Bool {
//                print("MES NOT \(messageRead)")
//                if messageRead == false {
//                    self.messages.badgeCount = self.messages.badgeCount + 1
//                    self.messages.messageCount = self.messages.messageCount + 1
//                    self.dropMenuButton.badge = self.messages.badgeCount
//                    self.matches.badge = self.messages.messageCount
//
//                }
//            }
//            }
//        }
//    }
//    
//    
//    func presentVC(MaleID: String,MaleName: String){
//        let notificationPressed = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child(userID!).child(firstNametextLable).child(MaleID)
//        notificationPressed.observe(.value) { (snap) in
//            let snapValue = snap.value as! NSDictionary
//            if let notifyPressed = snapValue["Pressed "] as? Bool {
//                if notifyPressed == true {
////                    print("NOTIFY PRESSED \(notifyPressed) from \(MaleName)")
//                    self.messages.maleId = MaleID
//                    self.messages.maleName = MaleName
//                    notificationPressed.updateChildValues(["Pressed ": false])
//                    self.performSegue(withIdentifier: "goToChatDirectly", sender: self)
//                }
//            }
//            
//        }
//        
//    }
//    func checkPotentialMatches(){
//        
//        let ref = Database.database().reference().child("users").child("Male")
//        ref.observe(.childAdded) { (snapshot) in
//            let ref2 = ref.child(snapshot.key)
//            
//            ref2.observe(.value, with: { (snap) in
//                let snapValue = snap.value as! NSDictionary
//                //                print("Potential Matched users are \(snapshot)")
//                
//                
//                if (snapValue["Description "] as? String) != nil{
//                    self.potentialMatches.count = self.potentialMatches.count + 1
//                }
//            })
//        }
//    }
//    @IBAction func checkPotentialMatches(_ sender: Any) {
//
//        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child(userID!)
//        ref.observe(.value) { (snapshot) in
//            
//            let snapValue = snapshot.value as! NSDictionary
//            if (snapValue["Description "] as? String) != nil{
//                if self.potentialMatches.count == 0 {
//                    self.alertTheUser(title: "Sorry but we are still finding users that share your interests ", message: "Keep swiping so that we can judge your interests better. ")
//                }else{
//                    self.performSegue(withIdentifier: "PotentialMatch", sender: self)
//                }
//            }else{
//                self.alertUserProfile(title: "Write a description about yourself.", message: "Check out your profile to write a description about yourself. This will help us find some potential matches for you.")
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.YourProfileButtonView.backgroundColor = UIColor.flatYellowColorDark()
//                    self.YourProfileButtonView.translatesAutoresizingMaskIntoConstraints = false
//                    self.YourProfileButtonView.layer.masksToBounds = true
//                    self.YourProfileButtonView.layer.cornerRadius = 6
//                })
//                
//            }
//        }
//    }
//    func alertUserProfile(title: String, message: String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            
//            alert.dismiss(animated: true, completion: nil)
//            UIView.animate(withDuration: 0.25, animations: {
//                self.YourProfileButtonView.backgroundColor = UIColor.clear
//                
//            })
//            
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "goToMatches" {
//            let destinationVC = segue.destination as! UserTableFemaleTableViewController
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.Ids = messages.IDS
//            destinationVC.maleNames = messages.finalMatch
//            destinationVC.profilePicURL = messages.profilePicURL
//            destinationVC.gender = "Female"
//            destinationVC.age = age
//        }
//        
//        if segue.identifier == "goToSettings" {
//            let destinationVC = segue.destination as! SettingsViewController
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.gender = "Female"
//        }
//        if segue.identifier == "goToChatsDirectly" {
//            let destinationVC = segue.destination as! ChatLogController
//            
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.names = messages.finalMatch
//            destinationVC.IDs = messages.IDS
//            destinationVC.profilePicURL = messages.profilePicURL
//            destinationVC.age = age
//            destinationVC.gender = "Male"
//            destinationVC.currentUsersGender = "Female"
//            destinationVC.id = messages.maleId
//            destinationVC.name = messages.maleName
//        }
//        if segue.identifier == "goToChatDirectly" {
//            let destinationVC = segue.destination as! UserTableFemaleTableViewController
//            
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.maleNames = messages.finalMatch
//            destinationVC.Ids = messages.IDS
//            destinationVC.profilePicURL = messages.profilePicURL
//            destinationVC.age = age
//            destinationVC.gender = "Male"
//            destinationVC.currentUsersGender = "Female"
//            destinationVC.maleId = messages.maleId
//            destinationVC.maleName = messages.maleName
//            destinationVC.newMessageReceived = true
//
//        }
//        if segue.identifier == "PopUpMatch" {
//            let destinationVC = segue.destination as! PopNewMatchViewController
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.femaleNames = messages.finalMatch
//            destinationVC.Name = messages.oneMatch_Name
//            destinationVC.IDs = messages.IDS
//            destinationVC.pic = messages.profilePic
//            destinationVC.gender = "Female"
//        }
//        if segue.identifier == "ProfileUpdate"{
//            let destinationVC = segue.destination as! ProfileUpdateViewController
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.gender = "Female"
//            
//        }
//
//        if segue.identifier == "PotentialMatch" {
//            let destinationVC = segue.destination as! PotentialMatchVC
//            destinationVC.firstNametextLable = firstNametextLable
//            destinationVC.gender = "Male"
//            destinationVC.currentUserGender = "Female"
//        }
//        if segue.identifier == "ShowInfo" {
//            let destinationVC = segue.destination as! ShowDescriptionViewController
//            destinationVC.gender =  "Male"
//            destinationVC.id = showInfo.Id
//            
//        }
//    }
//
//    
//    @IBAction func matchesPressed(_ sender: Any) {
//        
//        if messages.finalMatch.count>0{
//            performSegue(withIdentifier: "goToMatches", sender: self)
//        }else{
//            alertTheUser(title: "You have no matches. Keep swiping 🥰", message: "")
//        }
//    }
//    
//    
//    func alertTheUser(title: String, message: String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        
//        self.present(alert, animated: true, completion: nil)
//        
//    }
//}
//
//extension FemaleSearchPartnerViewController : TinderCardFemaleDelegate{
//    
//    // action called when the card goes to the left.
//    func cardGoesLeft(card: TinderCardFemale) {
//        removeObjectAndAddNewValues()
//    }
//    // action called when the card goes to the right.
//    func cardGoesRight(card: TinderCardFemale) {
//        removeObjectAndAddNewValues()
//    }
//    func currentCardStatus(card: TinderCardFemale, distance: CGFloat) {
//        
//        if distance == 0 {
//            emojiView.rateValue =  2.5
//        }else{
//            let value = Float(min(fabs(distance/100), 1.0) * 5)
//            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
//            emojiView.rateValue =  sorted
//        }
//        
//        
//    }
//}
//
//
