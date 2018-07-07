//
//  profileSetUpViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 27/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import ChameleonFramework
import SDWebImage
import MobileCoreServices
import AVKit
import SwiftKeychainWrapper

class profileSetUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var maleImageView: UIImageViewX!
    @IBOutlet weak var femaleImageView: UIImageViewX!
    
    @IBOutlet weak var firstNameTextLabel: UITextField!
    
    var userUid: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
//    private static let _instance1 = profileSetUpViewController()
//
//    static var Instance: profileSetUpViewController {
//        return _instance1
//    }
//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        // Do any additional setup after loading the view.
    }
    func keyChain() {
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextToProfileVcPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "goToProfileVC", sender: self)

        
    }
    

  
    
    @IBAction func femaleNextToProfileVcPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToFemaleProfileVC", sender: self)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileVC" {
            let destinationVC = segue.destination as! YourProfileViewController
            destinationVC.stringHolder = firstNameTextLabel.text!
            destinationVC.ProfilePic = maleImageView
        }  else if segue.identifier == "goToFemaleProfileVC" {
            
            let destinationVC = segue.destination as! YourProfileViewController
            destinationVC.stringHolder = firstNameTextLabel.text!
            destinationVC.ForFemaleProfilePic = femaleImageView
            
        }
    }
    

    
    //    @IBAction func WomanPressed(button: UIButton) {
//        
//        if button.isSelected {
//        
//            button.backgroundColor = UIColor.red
//    
//        }
//    }
//    @IBAction func ManPressed(button: UIButton) {
//        if button.isSelected {
//            
//            button.backgroundColor = UIColor.red
//            
//        }
//    }
    
    @IBAction func maleAttachmentPressed(_ sender: UIButton) {
        let uiimage = UIImagePickerController()
        uiimage.delegate = self
        
        uiimage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        uiimage.allowsEditing = true
        
        self.present(uiimage, animated: true)
        {
            //Code after it is completed
            
        }
    }
    
 
    
        
    
    
    
    
    @IBAction func femaleAttachmentPressed(_ sender: UIButton) {
        
        let uiimage = UIImagePickerController()
        uiimage.delegate = self
        
        uiimage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        uiimage.allowsEditing = true
        
        self.present(uiimage, animated: true)
        {
            //Code after it is completed
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        

        if let uiimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            maleImageView.image = uiimage
            //femaleImageView.image = uiimage
            
        
        } else {
          //Print error
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func uploadImg() {
        
        guard let img = maleImageView.image , imageSelected == true else {
            print("Image must be selected")
            return
        }
        //Posting data to server
        func setUpUser() {
            let userData = [
                "username": NSUserName(),
                "userImage": img
                ] as [String : Any]
            keyChain()
            let setLocation = Database.database().reference().child("users").child(userUid)
            setLocation.setValue(userData)
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let storageReference = Storage().reference().child(imgUid)

            let localFile = URL(string: "path/to/image")!
            let metaData = StorageMetadata()
            metaData.contentType = "img/jpeg"
            
            storageReference.putData(imgData, metadata: metaData)
            
            storageReference.putFile(from: localFile, metadata: metaData)
            
           // let downloadURL =
            
            
            
        }
    }
    
}












