//
//  PotentialMatchVCViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 14/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//


import UIKit
import Firebase

class PotentialMatchVC: UIViewController {

    @IBOutlet weak var TopVIew: UIView!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var CheckBackLater: UILabel!
    
    var matches = [Matches]()
    var matchedUsers : [potentialMatchedUsers] = [potentialMatchedUsers]()
    var potentialUsers = potentialMatchedUsers()
    var messages = message()
    var notification = NotificationPublisher()
    var gender : String!
    var firstNametextLable : String!
    var currentUserGender : String!
    var user = User()
    var age : Int!
    var Names = [String]()
    var namesSwipped = [String]()
    var userID = Auth.auth().currentUser?.uid
    var currentIndex = 0
    var ref: DatabaseReference!
    var tinderCard : TinderCard!
    var currentLoadedCardsArray = [TinderCard]()
    var allCardsArray = [TinderCard]()
    var cardArray = [UIView]()
    var checkFemaleSwipes : String!
    var checkMaleSwipes : String!
    var pics = [String]()
    var names = [String]()
    var ids = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TopVIew.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
        getPotentialUsers()
        CheckBackLater.isHidden = true
//        getPotentialMatchedUser()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        //loadCardValues()
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getPotentialUsers() {
        let currentRef = Database.database().reference().child("users").child(currentUserGender).child(Auth.auth().currentUser!.uid)
        
        currentRef.observe(.value) { (snap1) in
            if let snapValue = snap1.value as? NSDictionary {
            if let CurrentUsersDescription = snapValue["Description "] as? String{
                self.potentialUsers.CurrentUsersDesription = CurrentUsersDescription
                let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                let components = CurrentUsersDescription.components(separatedBy: chararacterSet)
                let words = components.filter { !$0.isEmpty }
                self.potentialUsers.currentDescriptionWords = words
            }
            }
            
        }
        let ref = Database.database().reference().child("users").child(gender)
        ref.observe(.childAdded) { (snapshot) in
            let ref2 = ref.child(snapshot.key)
            self.potentialUsers.count = 0

            ref2.observe(.value, with: { (snap) in
                let snapValue = snap.value as! NSDictionary
                
                
                if let description = snapValue["Description "] as? String{
                    
                    let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                    let components = description.components(separatedBy: chararacterSet)
                    let words = components.filter { !$0.isEmpty }
                    
                    print(" USERS DES \(self.potentialUsers.CurrentUsersDesription))")
                    
                    for word in words {
                        if self.potentialUsers.currentDescriptionWords.contains(word) {
                            self.potentialUsers.percentageC = self.potentialUsers.percentageC + 1
                        }
                    }
                    print("WORDS THAT MATCH ARE \(self.potentialUsers.percentageC)")
                    let percentageMatched = CGFloat((self.potentialUsers.percentageC/Float(words.count))*100)
                    print("PERCENTAGE OF MATCHED WORDS IS \(percentageMatched)")
                    if percentageMatched >= 55 {
                        self.potentialUsers.count = self.potentialUsers.count + 1
                        ref2.updateChildValues(["MATCH PERCENTAGE ": "percentageMatched"])
                        self.getPotentialMatchedUser()

                    }
                    
                }
            })
        }

    }

    func getPotentialMatchedUser()  {
        let ref = Database.database().reference().child("users").child(gender)
        ref.observe(.childAdded) { (snapshot) in
            let ref2 = ref.child(snapshot.key)
            ref2.observe(.value, with: { (snap) in
                let snapValue = snap.value as! NSDictionary
                if let matchedPercentage = snapValue["MATCH PERCENTAGE "] as? String {
                    let name = snapValue["Name "] as? String
                    let id = snapValue["UserId "] as? String
                    let profilePicURL = snapValue["Profile Pic "] as? String
                    self.potentialUsers.pics.append(profilePicURL!)
                    self.potentialUsers.ids.append(id!)
                    self.potentialUsers.names.append(name!)
                    print("Potential Matched users are \(self.potentialUsers.count)")
                    if self.potentialUsers.count == self.potentialUsers.pics.count{
                        self.loadCardValues(pics: self.potentialUsers.pics, names: self.potentialUsers.names, receiverIds: self.potentialUsers.ids)

                    }else{
                    }
                }
            })
        }
    }
    
    func loadCardValues(pics: [String], names: [String],receiverIds: [String]) {
//        print("COUNT OF USERS WITH SAME pic \(potentialUsers.pics.count)")

        if pics.count > 0 {
            
            let capCount = (pics.count > MAX_BUFFER_SIZE1) ? MAX_BUFFER_SIZE1 : pics.count
            
            for (i,pic) in potentialUsers.pics.enumerated() {
                let newCard = createTinderCard(at: i,pic: pics[i],name: names[i],Id: receiverIds[i])
                
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

    }
    
    
    func createTinderCard(at index: Int , pic :String, name: String, Id: String) -> TinderCard {
        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic, name: name,Id : Id)
        card.delegate = self
        user.name = name
        user.id = Id
        return card
    }
    
    func removeObjectAndAddNewValues() {
        
    
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        potentialUsers.count = currentLoadedCardsArray.count
        checkCardStack()

        print("CURRENT INDEX IS \(currentIndex)")
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
    
    
    
//    func femaleSwippedMale(values: [String: AnyObject]) {
//        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
//        let usersChildRef = ref.child("users").child("FSM").child(userID!)
//
//        usersChildRef.updateChildValues(values)
//
//    }
//
//    func initiateChat() {
//        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(checkFemaleSwipes)
//        print("INITIATE CHAT")
//
//        ref.observe(.childAdded, with: { (snapshot) in
//            //            print("Users in Female swipped Male database are::\(snapshot) ")
//
//            for name in snapshot.children {
//                self.Names.append((name as AnyObject).key)
//                let childSnap = name as! DataSnapshot
//                //                print("The male names are \(self.maleNames)")
//                //                print("KEYY IS : \(childSnap.key)")
//                for names in childSnap.children {
//                    let snap = names as! DataSnapshot
//                    //                    print("The names of the females that this male-- \(name)  has liked are \(females)")
//                    self.namesSwipped.append((names as AnyObject).key)
//
//
//                }
//                for names in self.namesSwipped {
//                    //                    print("The names of males being checked are \(names)")
//                    if(self.userID == names){
//                        //                        print("YAYY THE HOT GUY::\(name) LIKES YOU::\(self.firstNametextLable)")
//
//                        self.checkMatch(Id: snapshot.key, Name: childSnap.key)
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
//    func checkMatch(Id: String,Name : String) {
//        let ref2 = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(checkMaleSwipes).child(userID!)
//
//
//        ref2.observe(.childAdded) { (snapshot) in
//            for id in snapshot.children {
//                //                if snapshot.key == self.firstNametextLable {
//                if (id as AnyObject).key == Id {
//
//                    let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(self.currentUserGender).child(Id)
//                    ref.observeSingleEvent(of: .value) { (snap) in
//                        let snapshotValue = snap.value as! NSDictionary
//                        let profilePicURl = snapshotValue["Profile Pic "]
//
//                        self.matchFound(Id: Id, Name: Name, pic: profilePicURl as! String)
//
//                    }
//                }
//                //                }
//            }
//        }
//    }
//
//    func matchFound(Id: String,Name : String,pic: String) {
//
//        messages.profilePicURL.append(pic)
//        messages.IDS.append(Id)
//        messages.finalMatch.append(Name)
//        messages.maleName = Name
//        messages.maleId = Id
//        messages.imageURL = pic
//
//        notification.name = Name
//        notification.id = Id
//        notification.firstNametextLable = firstNametextLable
//
//        let badgeCountRef = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child(currentUserGender).child(userID!).child(firstNametextLable).child(Id)
//        badgeCountRef.updateChildValues(["Badge ": 1])
//        badgeCountRef.observe(.value) { (snapshot) in
//            let snapshotValue = snapshot.value as? NSDictionary
//            if  let badgeAdded = snapshotValue!["Badge added "] as? String {
//            }else{
//                self.messages.badgeCount = self.messages.badgeCount + 1
////                self.dropMenuButton.badge = self.messages.badgeCount
////                self.matches.badge = self.messages.badgeCount
//                print("BADGE COUNT IS \(self.messages.badgeCount)")
//
//                if self.messages.badgeCount == 1 {
//                    self.messages.oneMatch_Name = Name
//                    self.messages.profilePic = pic
//                    self.notification.sendNotification(title: "Match found", subtitle: "You have a new match", body: "You have been matched with \(Name)", badge: 1, delayInterval: 1)
//                    self.performSegue(withIdentifier: "PopUpMatch", sender: self)
//
//                }else{
//                    self.notification.sendNotification(title: "Multiple Matches found", subtitle: "Check out your matches page.", body: "", badge: 1, delayInterval: 1)
//                }
//            }
//        }
//    }
    
    
    
    func checkCardStack(){
        if potentialUsers.count == 0{
            CheckBackLater.isHidden = false
        }
    }
    
    
    
    
    
    
}
extension PotentialMatchVC : TinderCardDelegate{
    
    // action called when the card goes to the left.
    func cardGoesLeft(card: TinderCard) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: TinderCard) {
        removeObjectAndAddNewValues()
    }
    func currentCardStatus(card: TinderCard, distance: CGFloat) {
        
//        if distance == 0 {
//            emojiView.rateValue =  2.5
//        }else{
//            let value = Float(min(fabs(distance/100), 1.0) * 5)
//            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
//            emojiView.rateValue =  sorted
//        }
        
        
    }
}
