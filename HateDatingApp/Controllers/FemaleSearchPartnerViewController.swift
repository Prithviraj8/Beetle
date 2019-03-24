////
////  FemaleSearchPartnerViewController.swift
////  HateDatingApp
////
////  Created by Prithviraj Murthy on 09/09/18.
////  Copyright © 2018 Prithviraj Murthy. All rights reserved.
////
//
////
////let  MAX_BUFFER_SIZE = 3;
////let  SEPERATOR_DISTANCE = 8;
////let  TOPYAXIS = 75;
//
//import Foundation
//import UIKit
//import AVKit
//import MapKit
//import Firebase
//import FirebaseStorage
//import Alamofire
//import AlamofireImage
//@IBOutlet weak var buttonUndo: UIButton!
//@IBOutlet weak var viewActions: UIView!
////
//@IBOutlet weak var viewTinderBackGround: UIView!
//@IBOutlet weak var emojiView: EmojiRateView!
//class FemaleSearchPartnerViewController1: UIViewController, CLLocationManagerDelegate {
//    var userid : String = ""
//
//    let locationManager = CLLocationManager()
//    var divisor: CGFloat!
//    var storageRef: StorageReference!
//    //var profileImageUrl: String!
//    var ref : DatabaseReference!
//
//    var currentIndex = 0
//    var tinderCard : TinderCard!
//    var profilePic = [String]()
//    var names = [String]()
//    var currentLoadedCardsArray = [TinderCard]()
//    var allCardsArray = [TinderCard]()
//    var cardArray = [UIView]()
//    var valueArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36"]
//
//    var Count = [Int]()
//    var count : Int = 0
//
//
//    //Views---
//    @IBOutlet weak var Card: UIView!
//    @IBOutlet weak var viewActions: UIView!
//    @IBOutlet weak var emojiView: EmojiRateView!
//
//    //Buttons---
//    @IBOutlet weak var dislikeButton: UIButton!
//    @IBOutlet weak var undoButton: UIButton!
//    @IBOutlet weak var likeButton: UIButton!
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestLocation()
//
//        divisor = ((view.frame.width) / 2) / (0.61)
//        viewActions.alpha = 0
//        undoButton.alpha = 0
//
//        //        getImageCount()
//
//        fetchImagesAndPostThem()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        view.layoutIfNeeded()
//        //        loadCardValues()
//
//    }
//
//    @objc func animateEmojiView(timer : Timer){
//        let sender = timer.userInfo as! EmojiRateView
//        emojiView.rateValue =  emojiView.rateValue + 0.2
//        if sender.rateValue >= 5 {
//            timer.invalidate()
//            emojiView.rateValue = 2.5
//        }
//    }
//    //========================LOCATION MANAGER FUNCTIONS=============================
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse{
//            locationManager.requestLocation()
//
//
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if locations.first != nil {
//
//            let locationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
//
//            let currentLocation = CLLocation()
//            let locationLatitude = currentLocation.coordinate.latitude
//            let locationLongitude = currentLocation.coordinate.longitude
//
//            print("Location : \(locations) , \(locationValue.latitude) , \(locationValue.longitude)")
//            print("locations == \(locationLatitude)\(locationLongitude)\(currentLocation.coordinate.latitude)\(currentLocation.coordinate.longitude)")
//
//
//
//
//
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("ERROR: \(error)")
//    }
//
//    //==========================================================================
//
//    //    @IBAction func panGestureCard(_ sender: UIPanGestureRecognizer) {
//    //
//    ////        let card = sender.view!
//    ////        let point = sender.translation(in: view)
//    ////        let xFromCenter = card.center.x - view.center.x
//    ////
//    ////
//    ////
//    ////        let scale = min(100/abs(xFromCenter), 1)
//    ////
//    ////        //100/2 = 50/0.61 = 81.9672
//    ////        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
//    ////        //Affine means it preserves parellel relationships in an objext when it is rotated.
//    ////        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
//    ////
//    //////        card.transform = CGAffineTransform(rotationAngle: ((view.frame.width)/2)/0.61)
//    ////
//    ////        if xFromCenter > 0 {
//    ////
//    ////            ThumbsImageView.image = #imageLiteral(resourceName: "ThumbsUp")
//    ////            ThumbsImageView.tintColor = UIColor.green
//    ////
//    ////        }else{
//    ////
//    ////            ThumbsImageView.image = #imageLiteral(resourceName: "thumbsDown-1")
//    ////            ThumbsImageView.tintColor = UIColor.red
//    ////
//    ////        }
//    ////
//    ////        ThumbsImageView.alpha = abs(xFromCenter) / view.center.x
//    ////
//    ////
//    ////        if sender.state == UIGestureRecognizerState.ended {
//    ////
//    ////            if card.center.x < 75 {
//    ////                // Move off to the left side.
//    ////                UIView.animate(withDuration: 0.3) {
//    ////                    card.center = CGPoint(x: card.center.x - 200.0, y: card.center.y + 75)
//    ////                    card.alpha = 0
//    ////
//    ////                }
//    ////
//    ////                return//So that the reset code does not run
//    ////
//    ////            }else if card.center.x > (view.frame.width - 75) {
//    ////                //Move off to the right side.
//    ////                UIView.animate(withDuration: 0.3) {
//    ////                    card.center = CGPoint(x: card.center.x + 200.0, y: card.center.y + 75)
//    ////                    card.alpha = 0
//    ////                }
//    ////
//    ////                return//So that the reset code does not run
//    ////
//    ////                }
//    ////            }
//    ////           // resetCard()
//    //
//    //    }
//
//
//
//    func loadCardValues(pics: [String], names: [String]) {
//
//        print("allCardsArray is :: \(allCardsArray.count)")
//        print("currentLoadedCardsArray is :: \(currentLoadedCardsArray.count)")
//        print("profile Pic is ::;\(pics.count)")
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
//                let newCard = createTinderCard(at: i,pic: pic, name: names[i])
//
//                //Checking value array.
//                // print("The PIC IS ::  \(pic)")
//                print("\(i): '\(pic)'")
//
//                allCardsArray.append(newCard)
////                currentLoadedCardsArray.append(newCard)
//
//                //                Card.addSubview(allCardsArray[i])
//
//                print("CAP COUNT IS :\(capCount)")
//                                    if i < capCount {
//                                        currentLoadedCardsArray.append(newCard)
//                                        }
//
//                //}
//            }
//            print("profile Pic is ::;\(pics.count)")
//            print("allCardsArray is :: \(allCardsArray.count)")
//            print("currentLoadedCardsArray is :: \(currentLoadedCardsArray.count)")
//
//            for (i,_) in currentLoadedCardsArray.enumerated() {
//                if i > 0 {
//                    Card.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
//                }else {
//                    Card.addSubview(currentLoadedCardsArray[i])
//                }
//            }
//            animateCardAfterSwiping()
//            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
//        }
//        print("THE PROFILE PIC ARRAY IS EMPTY!!!!!!!")
//
//    }
//
//    @objc  func loadInitialDummyAnimation() {
//
//        let dummyCard = currentLoadedCardsArray.first;
//        //        let dummyCard = allCardsArray.first;
//        dummyCard?.shakeAnimationCard()
//        UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveLinear, animations: {
//            self.viewActions.alpha = 1.0
//
//        }, completion: nil)
//        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.animateEmojiView), userInfo: emojiView, repeats: true)
//    }
//
//    func removeObjectAndAddNewValues() {
//
//        emojiView.rateValue =  2.5
//        UIView.animate(withDuration: 0.5) {
//            self.undoButton.alpha = 0
//        }
//        print("The all cards array count is ::\(allCardsArray.count)")
//        print("The current loaded cards array count is ::\(currentLoadedCardsArray.count)")
//        allCardsArray.remove(at: 0)
////        currentLoadedCardsArray.remove(at: 0)
//        currentIndex = currentIndex + 1
//        Timer.scheduledTimer(timeInterval: 1.01, target: self, selector: #selector(enableUndoButton), userInfo: currentIndex, repeats: false)
//
//        //        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
//
//        if (currentIndex  + currentLoadedCardsArray.count) < allCardsArray.count {
//
//            print("currentLoadedCardsArray is :::\(currentLoadedCardsArray.count)")
//
//            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
//            var frame = card.frame
//            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
//            card.frame = frame
//            currentLoadedCardsArray.append(card)
//            Card.insertSubview(allCardsArray[MAX_BUFFER_SIZE - 1], belowSubview: allCardsArray[MAX_BUFFER_SIZE - 2])
//            print("allCardsArray is :::\(allCardsArray.count)")
//
//        }
//
//        print("The current Index is \(currentIndex)")
//        animateCardAfterSwiping()
//    }
//
//    func animateCardAfterSwiping() {
//
//        for (i,card) in allCardsArray.enumerated() {
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
//
//
//    func createTinderCard(at index: Int , pic :String, name:String) -> TinderCard {
//        let card = TinderCard(frame: CGRect(x: 0, y: 0, width: Card.frame.size.width , height: Card.frame.size.height - 50) ,pic : pic,name: name)
//        card.delegate = self as? TinderCardDelegate
//        return card
//    }
//
//
//    //    func resetCard() {
//    //
//    //        UIView.animate(withDuration: 0.2) {
//    //
//    //            self.Card.center = self.view.center
//    //            self.ThumbsImageView.alpha = 0
//    //            self.Card.alpha = 1
//    //            self.Card.transform = CGAffineTransform.identity//Restore original scale, rotation of the object.
//    //            //self.PartnerImage.alpha = 1
//    //
//    //
//    //
//    //        }
//    //    }
//
//    @IBAction func disLikeButtonAction(_ sender: Any) {
//
//        let card = currentLoadedCardsArray.first
//        card?.leftClickAction()
//    }
//
//    @IBAction func LikeButtonAction(_ sender: Any) {
//
//        let card = currentLoadedCardsArray.first
//        card?.rightClickAction()
//    }
//
//    @IBAction func undoButtonAction(_ sender: Any) {
//
//        currentIndex =  currentIndex - 1
//
////        if currentLoadedCardsArray.count   >= 0 {
//        if currentLoadedCardsArray.count == MAX_BUFFER_SIZE {
//            print("Current Loaded Cards Array \(currentLoadedCardsArray.count)")
//            print("The array count of images from firebase is : \(self.profilePic.count)")
//
//            let lastCard = currentLoadedCardsArray.last
//            lastCard?.rollBackCard()
//            currentLoadedCardsArray.removeLast()
//        }
//        print("The Current Index is :::\(currentIndex)")
//        let undoCard = currentLoadedCardsArray[currentIndex]
//        undoCard.layer.removeAllAnimations()
//        Card.addSubview(undoCard)
//        undoCard.makeUndoAction()
//        currentLoadedCardsArray.insert(undoCard, at: 0)
//        animateCardAfterSwiping()
//
//        if currentIndex == 0 {
//            UIView.animate(withDuration: 0.5) {
//                self.undoButton.alpha = 0
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
//                self.undoButton.alpha = 1.0
//            }
//        }
//    }
//
//
//
//
////    func fetchImagesAndPostThem() {
////        var count = 0
////        Firebase.Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male").observe(.childAdded, with: { (snapshot) in
////
////            let snapshotValue = snapshot.value as! Dictionary<String, String>
////            print("Users found : ")
////            print(snapshot)
////            let pic = snapshotValue["Profile Pic "]
////            let NAME = snapshotValue["Name "]
////            //            self.Count.append(self.count)
////            count = count + 1
////            self.profilePic.append(pic!)
////            self.names.append(NAME!)
////
////            print("The array of images from firebase is : \(self.profilePic)")
////            print("The array of names from firebase is : \(self.names)")
////            print("The array count of images from firebase is : \(self.profilePic.count)")
////
////
////            print("This is the last pic of the array : \(pic)")
////            print("This is the last name of the array : \(NAME)")
////            //
////            //            for(i,name) in self.names.enumerated(){
////            //
////            //                self.loadCardValues(name: name)
////            //
////            //            }
////            print("The profile pic count is :::\(self.profilePic.count)")
////
////
////            if self.profilePic.count == 6 {
////
////                print("The profile pic count is :::\(self.profilePic.count)")
////
////                self.loadCardValues(pics: self.profilePic)
////
////            }
////
////            //            print("The profile pic count is :::\(self.profilePic.count)")
////
////        }, withCancel: nil)
////
////        print("The array count of images from firebase is ::::: \(self.profilePic.count)")
////    }
//    func fetchImagesAndPostThem() {
//            var ref = Firebase.Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/").child("users").child("Male")
//
//            ref.observeSingleEvent(of: .value) { (snap) in
//                print("SNAP \(snap.childrenCount)")
//
//                var count = Int(snap.childrenCount)
//                let enumerator = snap.children
//                while let rest = enumerator.nextObject() as? [DataSnapshot] {
//                    print("REST IS \(rest.count)")
//                }
//                //observeSingleEvent just runs through the child or profile pic of only the first user and not through all of them.
//                //Therefore we use "observe" which does the opposite.
//                ref.observe(.childAdded, with: { (snapshot) in
//
//
//
//                    let snapshotValue = snapshot.value as! Dictionary<String, String>
//                    print("Users found : ")
//                    //          print("SNAPSHOT\(snapshot.childrenCount)")
//
//                    print(snapshot)
//                    let pic = snapshotValue["Profile Pic "]
//                    let NAME = snapshotValue["Name "]
//
//                    self.profilePic.append(pic!)
//                    self.names.append(NAME!)
//                    print("The profile pic count is :::\(self.profilePic.count)")
//
//                    print("The Count of Images is \(count)")
//                    if self.profilePic.count == count {
//
//                        print("The profile pic count is :::\(self.profilePic.count)")
//
//                        self.loadCardValues(pics: self.profilePic, names: self.names)
//
//                    }
//                })
//
//
//
//
//
//            }
//            print("The profile pic count is :::\(self.profilePic.count)")
//
//        }
//
//
//}
//
//extension FemaleSearchPartnerViewController : TinderCardDelegate{
//
//    // action called when the card goes to the left.
//    func cardGoesLeft(card: TinderCard) {
//        removeObjectAndAddNewValues()
//
//    }
//    // action called when the card goes to the right.
//    func cardGoesRight(card: TinderCard) {
//        removeObjectAndAddNewValues()
//    }
//    func currentCardStatus(card: TinderCard, distance: CGFloat) {
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
