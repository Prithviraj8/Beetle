//
//  TinderCard.swift
//  PanGesture
//
//  Created by Prithviraj Murthy on 05/08/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import Foundation


//let NAMES = ["Adam Gontier","Matt Walst","Brad Walst","Neil Sanderson","Barry Stock","Nicky Patson"]

let THRESHOLD_MARGIN = (UIScreen.main.bounds.size.width/2) * 0.75
let SCALE_STRENGTH1 : CGFloat = 4
let SCALE_RANGE1 : CGFloat = 0.90

import UIKit
import Firebase

protocol TinderCardFemaleDelegate: NSObjectProtocol {
    func cardGoesLeft(card: TinderCardFemale)
    func cardGoesRight(card: TinderCardFemale)
    func currentCardStatus(card: TinderCardFemale, distance: CGFloat)
}

class TinderCardFemale: UIView{
    
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var originalPoint = CGPoint.zero
    var imageViewStatus = UIImageView()
    var overLayImage = UIImageView()
    var showInfoButton = UIButtonX()
    var isLiked = false
    var NAME : String = ""
    var ref = Database.database().reference()
    var ref2 : DatabaseReference!
    var user = User()
    weak var delegate: TinderCardFemaleDelegate?
    var receiverId : String = ""
    
    public init(frame: CGRect, pic: String, name: String,Id: String) {
        super.init(frame: frame)
        setupView(pic: pic, name: name, Id : Id)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(pic: String, name: String, Id: String) {
        
        // print("The NAME OF THE pic being viewed: \(name)")
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = false
        NAME = name
        receiverId = Id
        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
//        let infoRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showInfo))

        let backGroundImageView = UIImageView(frame:bounds)
     
        
        guard let url = URL(string: pic) else {
            
            return
        }
        
        //   self.postImage(url: url)
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("Failed while fetching images : \(error?.localizedDescription)")
                return
            } else {
                
                print("Successfully fetched images from database ")
                //Posting the downloaded image from firbase database onto the imageView.
                DispatchQueue.main.async {
                    
                    //backGroundImageView.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
                    
                    
                    backGroundImageView.image = UIImage(data: data!)
                    backGroundImageView.contentMode = .scaleAspectFill
                    backGroundImageView.clipsToBounds = true;
                    self.addSubview(backGroundImageView)

                    
                    let labelText = UILabel(frame:CGRect(x: 90, y: self.frame.size.height - 80, width: self.frame.size.width - 100, height: 60))
                    
                    let attributedText = NSMutableAttributedString(string: name, attributes: [.foregroundColor: UIColor.white,.font:UIFont.boldSystemFont(ofSize: 25)])
                    //                        attributedText.append(NSAttributedString(string: "\n\(pic) mins", attributes: [.foregroundColor: UIColor.white,.font:UIFont.systemFont(ofSize: 18)]))
                    labelText.attributedText = attributedText
                    labelText.numberOfLines = 2
                    self.addSubview(labelText)
                    //let profileImageView = UIImageView(frame:CGRect(x: 20, y: self.frame.size.height - 80, width: 60, height: 60))

                    self.imageViewStatus = UIImageView(frame: CGRect(x: (self.frame.size.width / 2) - 37.5, y: 25, width: 75, height: 75))
                    self.imageViewStatus.alpha = 0
                    self.addSubview(self.imageViewStatus)
                    
                    self.overLayImage = UIImageView(frame:self.bounds)
                    self.overLayImage.alpha = 0
                    self.addSubview(self.overLayImage)
                    
//                    self.showInfoButton = UIButtonX(frame: CGRect(x: (self.frame.size.width - 60), y: 320, width: 37, height: 37))
//                    self.showInfoButton.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysOriginal), for: .normal)
//                    self.showInfoButton.addTarget(self, action: #selector(self.showInfo), for: .touchUpInside)
//                    self.addSubview(self.showInfoButton)
                    
                }
            }
            
        }).resume()
  
    }
    @objc func showInfo(){
        let showInfo = Show_Info()
        showInfo.name = NAME
        showInfo.Id = receiverId
        showInfo.gender = "Female"
    }
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
            break;
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH1, SCALE_RANGE1)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(xCenter)
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    
    func updateOverlay(_ distance: CGFloat) {
        
        imageViewStatus.image = distance > 0 ? #imageLiteral(resourceName: "btn_like_pressed") : #imageLiteral(resourceName: "btn_skip_pressed")
        overLayImage.image = distance > 0 ? #imageLiteral(resourceName: "overlay_like") : #imageLiteral(resourceName: "overlay_skip")
        imageViewStatus.alpha = min(fabs(distance) / 100, 0.5)
        overLayImage.alpha = min(fabs(distance) / 100, 0.5)
        delegate?.currentCardStatus(card: self, distance: distance)
    }
    //    func getLoggedInUserName(name: String) {
    //        firstNametextLable = name
    //    }
    
    func afterSwipeAction() {
        
        
        if xCenter > THRESHOLD_MARGIN {
            rightAction()
        }
        else if xCenter < -THRESHOLD_MARGIN {
            leftAction()
        }
        else {
            //reseting image
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: {
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.imageViewStatus.alpha = 0
                self.overLayImage.alpha = 0
                self.delegate?.currentCardStatus(card: self, distance:0)
            })
        }
    }
    
    
    
    func rightAction() {
        
        let finishPoint = CGPoint(x: frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesRight(card: self)
        print("WATCHOUT RIGHT")
        
        print("The NAME OF THE pic being viewed: \(self.NAME)")
        
        user.save_Info_For_Female_User_who_Swipped_A_Male_User(name: NAME, Id: receiverId)
        
        
    }
    
    func leftAction() {
        
        let finishPoint = CGPoint(x: -frame.size.width*2, y: 2 * yCenter + originalPoint.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.center = finishPoint
        }, completion: {(_) in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT")
        
    }
    
    // right click action
    func rightClickAction() {
        
        imageViewStatus.image = #imageLiteral(resourceName: "btn_like_pressed")
        overLayImage.image = #imageLiteral(resourceName: "overlay_like")
        let finishPoint = CGPoint(x: center.x + frame.size.width * 2, y: center.y)
        imageViewStatus.alpha = 0.5
        overLayImage.alpha = 0.5
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: 1)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = true
        delegate?.cardGoesRight(card: self)
        print("WATCHOUT RIGHT ACTION")
        
        print("The NAME OF THE pic being viewed: \(self.NAME)")
        
        
        user.save_Info_For_Female_User_who_Swipped_A_Male_User(name: NAME, Id: receiverId)
        
    }
    // left click action
    func leftClickAction() {
        
        imageViewStatus.image = #imageLiteral(resourceName: "btn_skip_pressed")
        overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
        let finishPoint = CGPoint(x: center.x - frame.size.width * 2, y: center.y)
        imageViewStatus.alpha = 0.5
        overLayImage.alpha = 0.5
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: -1)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        isLiked = false
        delegate?.cardGoesLeft(card: self)
        print("WATCHOUT LEFT ACTION")
    }
    
    // undoing  action
    func makeUndoAction() {
        
        imageViewStatus.image = isLiked ? #imageLiteral(resourceName: "btn_like_pressed") : #imageLiteral(resourceName: "btn_skip_pressed")
        overLayImage.image = isLiked ? #imageLiteral(resourceName: "overlay_like") : #imageLiteral(resourceName: "overlay_skip")
        imageViewStatus.alpha = 1.0
        overLayImage.alpha = 1.0
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.center = self.originalPoint
            self.transform = CGAffineTransform(rotationAngle: 0)
            self.imageViewStatus.alpha = 0
            self.overLayImage.alpha = 0
        })
        
        print("WATCHOUT UNDO ACTION")
    }
    
    func rollBackCard(){
        
        UIView.animate(withDuration: 0.5) {
            self.removeFromSuperview()
        }
    }
    
    func shakeAnimationCard(){
        
        imageViewStatus.image = #imageLiteral(resourceName: "btn_skip_pressed")
        overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.center = CGPoint(x: self.center.x - (self.frame.size.width / 2), y: self.center.y)
            self.transform = CGAffineTransform(rotationAngle: -0.2)
            self.imageViewStatus.alpha = 1.0
            self.overLayImage.alpha = 1.0
        }, completion: {(_) -> Void in
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.imageViewStatus.alpha = 0
                self.overLayImage.alpha = 0
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            }, completion: {(_ complete: Bool) -> Void in
                self.imageViewStatus.image = #imageLiteral(resourceName: "btn_like_pressed")
                self.overLayImage.image =  #imageLiteral(resourceName: "overlay_like")
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.imageViewStatus.alpha = 1
                    self.overLayImage.alpha = 1
                    self.center = CGPoint(x: self.center.x + (self.frame.size.width / 2), y: self.center.y)
                    self.transform = CGAffineTransform(rotationAngle: 0.2)
                }, completion: {(_ complete: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.imageViewStatus.alpha = 0
                        self.overLayImage.alpha = 0
                        self.center = self.originalPoint
                        self.transform = CGAffineTransform(rotationAngle: 0)
                    })
                })
            })
        })
        
        print("WATCHOUT SHAKE ACTION")
    }
    
}


