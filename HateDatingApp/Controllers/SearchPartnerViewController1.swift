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
    @IBOutlet weak var girlLikesButton: UIButton!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    var user = User()
    
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
    var fake = "PRITHVI"
    var currentLoadedCardsArray = [TinderCard]()
    var allCardsArray = [TinderCard]()
    var cardArray = [UIView]()
    var valueArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]
    
    var count : Int = 0
    var femaleIdsMatched = [String]()
    var receiverIds = [String]()
    var femaleNames = [String]()
    var namesSwippedByFemales = [String]()
    var namesSwippedByMales = [String]()
    var femaleNamesMatched = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getLoggedInUserInfo()
        
        viewActions.alpha = 0
        buttonUndo.alpha = 0
        fetchImagesAndPostThem()
        maleSwippedFemale(values: ["Name " : self.firstNametextLable] as [String : AnyObject])
//        user.firstNametextLable = firstNametextLable
//        firstNametextLable = user.name

        initiateChat()
//        dropMenuView.layer.shadowOpacity = 1
//        dropMenuView.layer.shadowRadius = 6
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
        
        
    }
    
    @IBAction func undoButtonAction(_ sender: Any) {
        
        currentIndex =  currentIndex - 1
        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE1 {
//            print("Current index is \(currentIndex)")
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
        var ref = Firebase.Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Female")
        
        ref.observeSingleEvent(of: .value) { (snap) in
//            print("SNAP \(snap.childrenCount)")
            
            var count = Int(snap.childrenCount)
            let enumerator = snap.children
            while let rest = enumerator.nextObject() as? [DataSnapshot] {
                print("REST IS \(rest.count)")
            }
            //                        ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
            //Therefore we user observe which does the opposite.
            ref.observe(.childAdded, with: { (snapshot) in
                
            
//                self.messages.receiverID = snapshot.key
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                print("Users found : ")

                let pic = snapshotValue["Profile Pic "]
                let NAME = snapshotValue["Name "]
                let receiverId = snapshotValue["UserId "]
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
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
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
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Female Swipped Male")
        print("INITIATE CHAT")
        
        ref.observe(.childAdded, with: { (snapshot) in
//            print("Users in Female swipped Male database are::\(snapshot) ")
            
            for name in snapshot.children {
                self.femaleNames.append((name as AnyObject).key)
                let childSnap = name as! DataSnapshot
                let key = childSnap.key

                for maleIds in childSnap.children {
       
                    self.namesSwippedByFemales.append((maleIds as AnyObject).key)
                    if(self.userID == (maleIds as AnyObject).key){
                        self.checkMatch(FemaleId: snapshot.key, FemaleName: childSnap.key)
                        break;
                        
                    }
                }
            }
        })
    }
   
    func checkMatch(FemaleId: String,FemaleName: String) {
        ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male Swipped Female").child(userID!)
        var maleNames = [String]()
     
        ref2.observe(.childAdded) { (snapshot) in
            for femaleId in snapshot.children {
//                if snapshot.key == self.firstNametextLable {

                    if (femaleId as AnyObject).key == FemaleId {
                            self.matchFound(FemaleId: FemaleId, FemaleName: FemaleName)
//                            self.femaleName = FemaleId
//                            print("The female Id matched is \(FemaleId)")
                        }
//                    }
//                }
            }
        }
    }
    var female_Name : String = ""
    var femaleId : String = ""
    
    func matchFound(FemaleId: String,FemaleName: String) {
//        ref2 = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users")
//        //Checking if a match is already found
//        let updateChildRef2 = ref2.child("Match").child("Male").child(firstNametextLable)
//        let updateChildRef3 = self.ref2.child("Match").child("Male").child(userID!).child(self.firstNametextLable).child(FemaleId).child(FemaleName)
////        updateChildRef3.updateChildValues(["MESSAGES " : "Messages", "Name ": FemaleName])

        messages.femaleIds.append(FemaleId)
        self.femaleIdsMatched.append(FemaleId)
        self.femaleNamesMatched.append(FemaleName)
        self.messages.finalMatch.append(FemaleName)
        
//        updateChildRef2.observe(.childAdded, with: { (snapshot) in
//            let id = snapshot.key
//
//            if (FemaleId == id) {
//                self.femaleId = id
//                self.female_Name = FemaleName
//
////                print("This couple is already matched . ")
////                print("FID  IS \((FemaleId))")
//
//            }else{
////                print("ID IS \(FemaleId)")
//                print("CREATING A NEW MATCH")
//
////                let updateChildRef3 = self.ref2.child("Match").child("Male").child(self.userID!).child(self.firstNametextLable)
//                updateChildRef3.updateChildValues(["MESSAGES " : "Messages", "Name ": FemaleName])
//
//            }
//
//        })
        
    }
    
   
//    func alertTheUser(title: String, message: String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        self.present(alert, animated: true, completion: nil)
//
//    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var finalMatch =  [String]()

        if segue.identifier == "goToChats" {
            let destinationVC = segue.destination as! UserTableViewController

            destinationVC.firstNametextLable = firstNametextLable
            destinationVC.femaleNames = messages.finalMatch
            destinationVC.IDs = messages.femaleIds
        }
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


