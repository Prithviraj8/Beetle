//
//  ExtraProfilePicCards.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 20/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol ExtraProfilePicCardsDelegate: NSObjectProtocol {
    func cardGoesLeft(card: ExtraProfilePicCards)
    func cardGoesRight(card: ExtraProfilePicCards)
    func currentCardStatus(card: ExtraProfilePicCards, distance: CGFloat)
}

class ExtraProfilePicCards: UIView{
    var names = [String]()
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
    weak var delegate: ExtraProfilePicCardsDelegate?
    var receiverId : String = ""
    
    
    
    public init(frame: CGRect, pic: String) {
        super.init(frame: frame)
        setupView(pic: pic)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(pic: String) {
        
        // print("The NAME OF THE pic being viewed: \(name)")
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        layer.shadowColor = UIColor.darkGray.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = false

        originalPoint = center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        //        let infoRecognizer = UIGestureRecognizer(target: self, action: #selector(self.showInfo))
        let backGroundImageView = UIImageView(frame:bounds)
        //        backGroundImageView.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
        //        backGroundImageView.contentMode = .scaleAspectFill
        //        backGroundImageView.clipsToBounds = true;
        //        addSubview(backGroundImageView)
        
        
        
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
//                    self.addSubview(labelText)

                    self.imageViewStatus = UIImageView(frame: CGRect(x: (self.frame.size.width / 2) - 37.5, y: 25, width: 75, height: 75))
                    self.imageViewStatus.alpha = 0
                    self.addSubview(self.imageViewStatus)
                    
                    self.overLayImage = UIImageView(frame:self.bounds)
                    self.overLayImage.alpha = 0
                    self.addSubview(self.overLayImage)
                    
                    
                    
                    
                }
            }
            
        }).resume()
        
        
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
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
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
        
        
        if xCenter > THERESOLD_MARGIN {
            rightAction()
        }
        else if xCenter < -THERESOLD_MARGIN {
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
        
        
        
    }
    // left click action
    func leftClickAction() {
        
        imageViewStatus.image = #imageLiteral(resourceName: "overlay_skip")
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
