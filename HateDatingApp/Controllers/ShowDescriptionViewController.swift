//
//  ShowDescriptionViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 19/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//
let  MAX_BUFFER_SIZE2 = 3;
let  SEPERATOR_DISTANCE2 = 8;
let  TOPYAXIS2 = 75;



import UIKit
import Firebase

class ShowDescriptionViewController: UIViewController {
    @IBOutlet weak var ProfilePic1: UIImageView!
    @IBOutlet weak var ProfilePic2: UIImageView!
    @IBOutlet weak var ProfilePic3: UIImageView!
    @IBOutlet weak var descriptionTL: UITextView!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButtonX!
    @IBOutlet weak var viewTinderBackGround: UIView!
    @IBOutlet weak var noImage: UIImageView!
    
    var gender : String!
    var id : String!
    var Pic3isHidden : Bool!
    var Pic1isHidden : Bool!
    var Pic2isHidden : Bool!

    
    var name : String!
    var messages = message()
    var notification = NotificationPublisher()
    var user = User()
    var userID = Auth.auth().currentUser?.uid
    var currentIndex = 0
    var ref: DatabaseReference!
    var tinderCard : ExtraProfilePicCards!
    var currentLoadedCardsArray = [ExtraProfilePicCards]()
    var allCardsArray = [ExtraProfilePicCards]()
    var cardArray = [UIView]()
    
    var pics = [String]()
    var names = [String]()
    var ids = [String]()
    
    
    let showInfo = Show_Info()
    override func viewDidLoad() {
        super.viewDidLoad()

//        TopView.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
        goBackButton.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
        getInfo()
    }
    func getInfo() {
        print("SHOW INFOR \(String(describing: showInfo.gender))")
        let ref = Database.database().reference().child("users").child(gender).child(id)
        ref.observe(.value) { (snap) in
            if let snapValue = snap.value as? NSDictionary {
                if let extraPic = snapValue["Extra pic2 "] as? String {
                    self.pics.append(extraPic)
                }
            
                if let extraPic = snapValue["Extra pic3 "] as? String {
                        self.pics.append(extraPic)
                }
                if let extraPic = snapValue["Extra pic4 "] as? String {
                    
                        self.pics.append(extraPic)
                }
                
               
                
                if let age = snapValue["Age "] as? Int {
                    self.ageLabel.text = String(age)
                }
                
                if let name = snapValue["Name "] as? String {
                    self.name = name
                
                if let description = snapValue["Description "] as? String {
                    self.descriptionTL.text = description
                }else{
                    if self.gender == "Male" {
                        self.descriptionTL.text = "\(name) has not provided a description about himself yet."
                        
                    }else{
                        self.descriptionTL.text = "\(name) has not provided a description about herself yet."

                    }
                }
                    
            }
                if self.pics.count == 0 {
                    self.noImage.isHidden = false
                }
                self.loadCardValues(pics: self.pics, names: self.names, receiverIds: self.showInfo.IDs)
            }
        }
    }
    
    func loadCardValues(pics: [String], names: [String],receiverIds: [String]) {
        if pics.count > 0 {
            
            let capCount = (pics.count > MAX_BUFFER_SIZE2) ? MAX_BUFFER_SIZE2 : pics.count
            
            for (i,pic) in pics.enumerated() {
                let newCard = createTinderCard(at: i,pic: pics[i])
                
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
//            perform(#selector(loadInitialDummyAnimation), with: nil, afterDelay: 1.0)
        }
        print("THE PROFILE PIC ARRAY IS EMPTY!!!!!!!")
        
    }
    
    
    @objc func loadInitialDummyAnimation() {
        
        let dummyCard = currentLoadedCardsArray.first;
        dummyCard?.shakeAnimationCard()
        
    }
    
    
    func createTinderCard(at index: Int , pic :String) -> ExtraProfilePicCards {
        let card = ExtraProfilePicCards(frame: CGRect(x: 0, y: 0, width: viewTinderBackGround.frame.size.width , height: viewTinderBackGround.frame.size.height - 50) ,pic : pic)
        card.delegate = self
    
        return card
    }
    
    func removeObjectAndAddNewValues() {
        
        
        currentLoadedCardsArray.remove(at: 0)
        currentIndex = currentIndex + 1
        
        print("CURRENT INDEX IS \(currentIndex)")
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count {
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE2 * SEPERATOR_DISTANCE2)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            viewTinderBackGround.insertSubview(currentLoadedCardsArray[MAX_BUFFER_SIZE2 - 1], belowSubview: currentLoadedCardsArray[MAX_BUFFER_SIZE2 - 2])
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
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE2)
                card.frame = frame
            })
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension ShowDescriptionViewController : ExtraProfilePicCardsDelegate{
    
    // action called when the card goes to the left.
    func cardGoesLeft(card: ExtraProfilePicCards) {
        removeObjectAndAddNewValues()
    }
    // action called when the card goes to the right.
    func cardGoesRight(card: ExtraProfilePicCards) {
        removeObjectAndAddNewValues()
    }
    func currentCardStatus(card: ExtraProfilePicCards, distance: CGFloat) {
        
        //        if distance == 0 {
        //            emojiView.rateValue =  2.5
        //        }else{
        //            let value = Float(min(fabs(distance/100), 1.0) * 5)
        //            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
        //            emojiView.rateValue =  sorted
        //        }
        
        
    }
}
