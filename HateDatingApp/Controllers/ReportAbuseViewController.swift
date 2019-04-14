//  ReportAbuseViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 08/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ReportAbuseViewController: UIViewController {

    
    
    
    @IBOutlet weak var writeReviewLabel: UILabel!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var submitReview: UIButtonX!
    
    
    var messages = message()
    var gender : String = ""
    var firstNameTextLabel : String = ""
    var profilePic : String = ""
    var profilePicURL = [String]()
    var IDs = [String]()
    var names = [String]()
    var id : String = ""
    var userID = Auth.auth().currentUser?.uid
    var name = ""
    var age : Int!
    var userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messageTV.delegate = self
//        messageTV.translatesAutoresizingMaskIntoConstraints = false
//        messageTV.layer.masksToBounds = true
        messageTV.layer.borderColor = UIColor.flatYellowColorDark()?.cgColor
        messageTV.layer.borderWidth = 2
        messageTV.layer.cornerRadius = 10
        messageTV.textColor = UIColor.black

        textViewDidBeginEditing(messageTV)
        textViewDidChange(messageTV)
        messageTV.text = "Write your review here."
        
        
        writeReviewLabel.translatesAutoresizingMaskIntoConstraints = false
        writeReviewLabel.layer.masksToBounds = true
        writeReviewLabel.layer.borderWidth = 2
        writeReviewLabel.layer.borderColor = UIColor.flatYellowColorDark()?.cgColor
        writeReviewLabel.layer.cornerRadius = 5
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func submitReviewPressed(_ sender: Any) {
        
        if gender == "Male"{
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Report Abuse").child("Male").child(userID!).child(firstNameTextLabel).child(id).child(name).child("Report")
            ref.childByAutoId().updateChildValues(["Report ": messageTV.text!])
        }else{
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Report Abuse").child("Female").child(userID!).child(firstNameTextLabel).child(id).child(name).child("Report")
            ref.childByAutoId().updateChildValues(["Report ": messageTV.text!])
        }
        
        
        
        alertTheUser(title: "Report Submitted", message: "You shall receive an email within 24-48 hours regarding the status of your report.")
    }
    
    
    func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)

        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}


extension ReportAbuseViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5) {
            // self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
            self.messageTV.text = ""
            self.messageTV.textColor = UIColor.black
            self.messageTV.layer.cornerRadius = 10
            self.messageTV.layer.borderColor = UIColor.flatYellowColorDark().cgColor
            self.messageTV.layer.borderWidth = 1
        }
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            sendButton.isEnabled = false
//        }else{
//            sendButton.isEnabled = true
//        }
        
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = messageTV.sizeThatFits(size)
        messageTV.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height < CGFloat(60){
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}


