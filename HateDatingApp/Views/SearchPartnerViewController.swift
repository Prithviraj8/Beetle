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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func panGestureCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        

    }
    
    

}
