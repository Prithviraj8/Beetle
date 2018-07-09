//
//  SearchPartnerViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 07/07/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import AVKit

class SearchPartnerViewController: UIViewController {



    @IBOutlet weak var Card: UIViewX!
    @IBOutlet weak var ThumbsImageView: UIImageView!
    
    var divisor: CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = ((view.frame.width) / 2) / (0.61)
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func panGestureCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        let scale = min(100/abs(xFromCenter), 1)
            
        //100/2 = 50/0.61 = 81.9672
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        //Affine means it preserves parellel relationships in an objext when it is rotated.
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
        
            ThumbsImageView.image = #imageLiteral(resourceName: "ThumbsUp")
            ThumbsImageView.tintColor = UIColor.green
            
        }else{
            
            ThumbsImageView.image = #imageLiteral(resourceName: "thumbsDown-1")
            ThumbsImageView.tintColor = UIColor.red
            
        }
        
        ThumbsImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizerState.ended {
        
            if card.center.x < 75 {
                // Move off to the left side.
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200.0, y: card.center.y + 75)
                    card.alpha = 0

                }
                return//So that the reset code does not run

            }else if card.center.x > (view.frame.width - 75) {
                //Move off to the right side.
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200.0, y: card.center.y + 75)
                    card.alpha = 0
                }
                return//So that the reset code does not run

            }
            resetCard()
            
        }
        
    }
    
    @IBAction func ResetCard(_ sender: UIButton) {
        resetCard()
    }
    
    func resetCard() {

        UIView.animate(withDuration: 0.2) {
            
            self.Card.center = self.view.center
            self.ThumbsImageView.alpha = 0
            self.Card.alpha = 1
            self.Card.transform = CGAffineTransform.identity//Restore original scale, rotation of the object.
        }
    }


    
}












