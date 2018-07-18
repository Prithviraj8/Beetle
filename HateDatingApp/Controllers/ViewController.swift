//
//  ViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 18/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import MapKit
import SwiftKeychainWrapper


class ViewController: UIViewController {

    @IBOutlet weak var toggleMenuView: UIView!
    @IBOutlet weak var getStarted: UIButton!
    @IBOutlet weak var clearFillView: UIViewX!
    
    @IBOutlet weak var SignUp: UIButton!
    @IBOutlet weak var Login: UIButton!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestLocation()
        SignUp.alpha = 0
        Login.alpha = 0
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            goToVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func getStartedPressed(_ sender: UIButton) {
        
        if self.clearFillView.transform == .identity {
            UIView.animate(withDuration: 1, animations: {
                self.clearFillView.transform = CGAffineTransform(scaleX: 10, y: 10)
                self.toggleMenuView.transform = CGAffineTransform(translationX: 0, y: -78)
                //self.getStarted.transform = CGAffineTransform(rotationAngle: 3.14)
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.toggleShareButtons()
                })
            }
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.toggleMenuView.transform = .identity
                self.getStarted.transform = .identity
                self.clearFillView.transform = .identity
            }) { (true) in
                
            }
        }
        
        
    }
    func toggleShareButtons() {
        let alpha = CGFloat(SignUp.alpha == 0 ? 1 : 0)
        SignUp.alpha = alpha
        Login.alpha = alpha
        }
    
    func goToVC() {
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
}

//extension ViewController : CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            print(location)
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//
//
//}

