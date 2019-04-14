//
//  UserDescriptionVC.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 12/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase

class UserDescriptionVC: UIViewController {


    @IBOutlet weak var topView2: UIView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var Done: UIButtonX!
    
    var userId = Auth.auth().currentUser?.uid
    var firstNametextLable : String!
    var gender : String!
    var user = User()


    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTV.delegate = self
        descriptionTV.translatesAutoresizingMaskIntoConstraints = false
        descriptionTV.layer.masksToBounds = true
        descriptionTV.layer.cornerRadius = 24
        descriptionTV.layer.borderWidth = 3
        descriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        topView2.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
        Done.translatesAutoresizingMaskIntoConstraints = false
        Done.layer.masksToBounds = true
        Done.setGradientBackground(colorOne: Colors.brightOrange, colorTwo: Colors.lightPink)
        textViewDidChange(descriptionTV)
        textViewDidBeginEditing(descriptionTV)
        descriptionTV.text = "Write your description here. You may also only type in keywords seperated by a comma (,) such as (coffee , workout, adventure)"
        descriptionTV.textColor = UIColor.lightGray
    }
    @IBAction func Done(_ sender: Any) {
        if descriptionTV.text != "Write your description here. You may also only type in keywords seperated by a comma (,) such as (coffee , workout, adventure)" {
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(gender).child(userId!)
            ref.updateChildValues(["Description  ": descriptionTV.text])
        }
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        descriptionTV.text = "Write your description here. You may also only type in keywords seperated by a comma (,) such as (coffee , workout, adventure)"
        descriptionTV.textColor = UIColor.lightGray
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension UserDescriptionVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.1) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            textView.text = ""
            textView.textColor = UIColor.black
            textView.layer.cornerRadius = 14
            textView.layer.borderColor = UIColor.lightGray.cgColor
            textView.layer.borderWidth = 3
        }
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Done.isEnabled = false
        }else{
            Done.isEnabled = true
        }
        
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = descriptionTV.sizeThatFits(size)
        descriptionTV.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height < CGFloat(300){
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}
