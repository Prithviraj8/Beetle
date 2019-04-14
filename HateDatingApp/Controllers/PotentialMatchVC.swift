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
    
    var matches = [Matches]()
    var matchedUsers : [potentialMatchedUsers] = [potentialMatchedUsers]()
    var users = potentialMatchedUsers()
    var gender : String!
    var firstNametextLable : String!
    var currentUserGender : String!
    var user = User()
    var age : Int!
    
    var IDs = [String]()
    var userID = Auth.auth().currentUser?.uid
    var currentIndex = 0
    var handler : Handler!
    var ref: DatabaseReference!
    var tinderCard : TinderCard!
    var profilePic = [String]()
    var name = [String]()
    var profilePicOfLoggedInUser : String!
    var currentLoadedCardsArray = [TinderCard]()
    var allCardsArray = [TinderCard]()
    var cardArray = [UIView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TopVIew.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
        getPotentialUsers()
        
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
        print("FIRST NAME IS \(firstNametextLable)CURR GEND IS \(currentUserGender) & GEN IS \(gender)")
        let currentRef = Database.database().reference().child("users").child(currentUserGender).child(Auth.auth().currentUser!.uid)
        
        
        let ref = Database.database().reference().child("users").child(gender)
        ref.observe(.childAdded) { (snapshot) in
            let ref2 = ref.child(snapshot.key)
            
            ref2.observe(.value, with: { (snap) in
                let snapValue = snap.value as! NSDictionary
                //                print("Potential Matched users are \(snapshot)")
                
                
                if let description = snapValue["Description  "] as? String{
                    let name = snapValue["Name "] as? String
                    let id = snapValue["UserId "] as? String
                    let profilePicURL = snapValue["Profile Pic "] as? String
                    self.users.name = name!
                    self.users.id = id!
                    self.users.profilePicURL = profilePicURL!
                    self.matchedUsers.append(self.users)
                    print("Potential Matched users are \(self.matchedUsers.count)")
                    let match = Matches(name: name, profilePic: profilePicURL)
                    self.matches.append(match)
                    print("MATCHES C IS \(self.matches.count)")
                    self.users.pics.append(profilePicURL!)
                    self.users.ids.append(id!)
                    self.users.names.append(name!)
                    self.loadCardValues(pics: self.users.pics, names: self.users.names, receiverIds: self.users.ids)
                }
            })
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
