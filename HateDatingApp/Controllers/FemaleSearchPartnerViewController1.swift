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
    
    
    var currentIndex = 0
    var handler : Handler!
    var ref : DatabaseReference!
    var tinderCard : TinderCardFemale!
    var profilePic = [String]()
    var name = [String]()
    var firstNametextLable : String = ""

    
    var currentLoadedCardsArray = [TinderCardFemale]()
    var allCardsArray = [TinderCardFemale]()
    var cardArray = [UIView]()
    var valueArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]
    
    //    var Count = [Int]()
    var count : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewActions.alpha = 0
        buttonUndo.alpha = 0
        fetchImagesAndPostThem()
        femaleSwippedMale(values: ["Name ": firstNametextLable as AnyObject])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        //loadCardValues()
    }
    
    @objc func animateEmojiView(timer : Timer){
        let sender = timer.userInfo as! EmojiRateView
        emojiView.rateValue =  emojiView.rateValue + 0.2
        if sender.rateValue >= 5 {
            timer.invalidate()
            emojiView.rateValue = 2.5
        }
    }
    
    
    //    func loadCardValues() {
    //
    //        if valueArray.count > 0 {
    //
    //            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
    //
    //            for (i,value) in valueArray.enumerated() {
    //                let newCard = createTinderCard(at: i,value: value)
    //                print("The VALUE IS ::: \(value)")
    //                allCardsArray.append(newCard)
    //                if i < capCount {
    //                    currentLoadedCardsArray.append(newCard)
    //                }
    //            }
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
    //        print("allCardsArray is :: \(allCardsArray.count)")
    //
    //    }
    func loadCardValues(pics: [String], names: [String]) {
        
        print("allCardsArray is :: \(allCardsArray.count)")
        print("currentLoadedCardsArray is :: \(currentLoadedCardsArray.count)")
        print("profile Pic is ::;\(pics.count)")
        print("The Names array Count is ::\(names.count)")
        if pics.count > 0 {
            
            let capCount = (pics.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : pics.count
            
            
            
            
            for (i,pic) in pics.enumerated() {
                //   for(i,name) in names.enumerated() {
                
                //            for i in 1...pics.count && && i < names.count {
                let newCard = createTinderCard(at: i,pic: pic,name: names[i] )
                
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
            print("profile Pic is ::;\(pics.count)")
            print("allCardsArray is :: \(allCardsArray.count)")
            print("currentLoadedCardsArray is :: \(currentLoadedCardsArray.count)")
            
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
    
    //    func createTinderCard(at index: Int , value :String) -> TinderCard {
    //
    //        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,value : value)
    //        card.delegate = self
    //        return card
    //    }
    func createTinderCard(at index: Int , pic :String, name: String) -> TinderCardFemale {
        let card = TinderCardFemale(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic, name: name)
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
        alertTheUser(title: "MATCH FOUND", message: "YOU HAVE A MATCH")
        print("MATCH FOUND")
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
    
//    func fetchImagesAndPostThem() {
//        ref = Firebase.Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male")
//
//        ref.observeSingleEvent(of: .value) { (snap) in
//            print("SNAP \(snap.childrenCount)")
//
//            var count = Int(snap.childrenCount)
//            let enumerator = snap.children
//            while let rest = enumerator.nextObject() as? [DataSnapshot] {
//                print("REST IS \(rest.count)")
//            }
//            //                        ref.observeSingleEvent(of: .childAdded) { (snapshot) in
//            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
//            //Therefore we user observe which does the opposite.
//            self.ref.observe(.childAdded, with: { (snapshot) in
//
//
//                print("Users Found: \(snapshot)")
//
//                let snapshotValue = snapshot.value as! Dictionary<String, String>
//                print("Users found : ")
//                //          print("SNAPSHOT\(snapshot.childrenCount)")
//
//                print(snapshot)
//                let pic = snapshotValue["Profile Pic "]
//                let NAME = snapshotValue["Name "]
//
//                self.profilePic.append(pic!)
//                self.name.append(NAME!)
//
//                print("The profile pic count is :::\(self.profilePic.count)")
//                print("The names array count is ::\(self.name.count)")
//                print("The Count of Images is \(count)")
//
//                if self.profilePic.count == count {
//
//                    print("The profile pic count is :::\(self.profilePic.count)")
//
//                    self.loadCardValues(pics: self.profilePic, names: self.name)
//
//                }
//            })
//
//
//
//
//
//        }
//        print("The profile pic count is :::\(self.profilePic.count)")
//
//    }
    func fetchImagesAndPostThem() {
        var ref = Firebase.Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male")
        
        ref.observeSingleEvent(of: .value) { (snap) in
            print("SNAP \(snap.childrenCount)")
            
            var count = Int(snap.childrenCount)
            let enumerator = snap.children
            while let rest = enumerator.nextObject() as? [DataSnapshot] {
                print("REST IS \(rest.count)")
            }
            //                        ref.observeSingleEvent(of: .childAdded) { (snapshot) in
            //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
            //Therefore we user observe which does the opposite.
            ref.observe(.childAdded, with: { (snapshot) in
                
                
                print("Users Found: \(snapshot)")
                
                let snapshotValue = snapshot.value as! Dictionary<String, String>
                print("Users found : ")
                //          print("SNAPSHOT\(snapshot.childrenCount)")
                
                print(snapshot)
                let pic = snapshotValue["Profile Pic "]
                let NAME = snapshotValue["Name "]
                //                self.tinderCard.NAME = NAME!
                print("The NAME is :\(NAME)")
                self.profilePic.append(pic!)
                self.name.append(NAME!)
                
                print("The profile pic count is :::\(self.profilePic.count)")
                print("The names array count is ::\(self.name.count)")
                print("The Count of Images is \(count)")
                
                if self.profilePic.count == count {
                    
                    print("The profile pic count is :::\(self.profilePic.count)")
                    
                    //                    self.tinderCard.NAME = self.name.first!
                    self.loadCardValues(pics: self.profilePic, names: self.name)
                    
                }
            })
            
            
            
        }
        print("The profile pic count is :::\(self.profilePic.count)")
        
    }
    func femaleSwippedMale(values: [String: AnyObject]) {
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
        let usersChildRef = ref.child("users").child("FSM").child(userID!)
        // TinderCard.getLoggedInUserName()
        //  tinderCard.getLoggedInUserName(name: firstNametextLable)
        print("The user ID is : \(String(describing: userID))")
        usersChildRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
                
            } else {
                print("The names of female users that the current logged in user swipped is being SAVED")
                //   print("The female name swipped by the logged in user is \(self.femaleName)")
                
            }
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


