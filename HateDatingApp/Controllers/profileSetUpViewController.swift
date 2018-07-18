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
    
    let user : [User] = [User]()
    var userUid: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var emailTextField : String?
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
        //uploadImg()
        // Do any additional setup after loading the view.
    }
//    func keyChain() {
//        KeychainWrapper.standard.set(userUid, forKey: "uid")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextToProfileVcPressed(_ sender: Any) {
        
        
    
        //self.performSegue(withIdentifier: "goToMaleProfileVC", sender: self)
        //Saving image to Firebase
        let imageName = NSUUID().uuidString
        let storageRef: StorageReference!
        storageRef = Storage.storage().reference(forURL: "gs://hatedateapp-ea81a.appspot.com").child("\(imageName).png").child("Male Image")
      
        let uploadData = NSData()
        storageRef.putData(uploadData as Data, metadata: nil) { (metaData, error) in
            if error != nil {
                print("Error while uploading image")
            } else {
            print("Successfully saved images to database")
                
            }
        }
        
        
//        if let uploadData = UIImagePNGRepresentation(self.maleImageView.image!) {
//
//
//
//            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("ERROR while uploading image: \(error)")
//                    return
//                }
//                print("Successfully saved image to firebase")
//
////                let ref: DatabaseReference!
////                ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
////                let usersChildRef = ref.child("users").child(self.userUid)
//
//                if let profileImageURL = metadata {
//
//                    metadata?.contentType = "img/jpeg"
//                    let values = ["Profile Image": metadata]
//                    //usersChildRef.updateChildValues(values)
//                    print(metadata)
//                    self.registerUserIntoDatabaseWithUID( values: values as [String : AnyObject])
//
//                }
//            }
//
//        }
        
    }
    

    @IBAction func ContinuePressed(_ sender: Any) {
    
        let ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
        let values = ["Name": firstNameTextLabel.text, "Email": emailTextField]
        let usersChildRef = ref.child("users").childByAutoId()
        usersChildRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
            }else{
                print("Successfully saved email and name in Firebase database")
                
            }
        }
    }
    
    
    @IBAction func femaleNextToProfileVcPressed(_ sender: Any) {
        
        //Saving image to Firebase
        let imageName = NSUUID().uuidString
        let storageRef: StorageReference!
        storageRef = Storage.storage().reference(forURL: "gs://hatedateapp-ea81a.appspot.com").child("\(imageName).png").child("Female Image")
        
        let uploadData = NSData()
        storageRef.putData(uploadData as Data, metadata: nil) { (metaData, error) in
            if error != nil {
                print("Error while uploading image")
            } else {
                print("Successfully saved images to database")
                //self.performSegue(withIdentifier: "goToFemaleProfileVC", sender: self)

            }
        }
//        if let uploadData = UIImagePNGRepresentation(self.femaleImageView.image!) {
//
//            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("ERROR while uploading image: \(error)")
//                    return
//                }
//                print("Successfully saved image to firebase")
////                let ref: DatabaseReference!
////                ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
////                let usersChildRef = ref.child("users").child(self.userUid)
//
//                if let profileImageURL = metadata {
//                    metadata?.contentType = "img/jpeg"
//                    let values = ["Profile Image": metadata]
//                  //  usersChildRef.updateChildValues(values)
//
//                    print(metadata)
//                    self.registerUserIntoDatabaseWithUID( values: values as [String : AnyObject])
//
//                }
////            }
//
//        }
       
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToMaleProfileVC" && firstNameTextLabel.text != nil {
//            let destinationVC = segue.destination as! MaleProfileViewController
//
//            destinationVC.stringHolder = firstNameTextLabel.text!
//            destinationVC.ProfilePic = maleImageView
//
//        }  else if segue.identifier == "goToFemaleProfileVC" {
//
//            let destinationVC = segue.destination as! FemaleProfileViewController
//            destinationVC.stringHolder = firstNameTextLabel.text!
//            destinationVC.ForFemaleProfilePic = femaleImageView
//
//        }
//    }
//

    
   
//    private func registerUserIntoDatabaseWithUID(values: [String: AnyObject]){
//
//        var ref : DatabaseReference!
//        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
//        let usersChildRef = ref.child("users").childByAutoId()
//      //  let values = ["Profile Image": metadata.downloadUrl()]
//        usersChildRef.updateChildValues(values) { (error, ref) in
//            if error != nil {
//                print(error)
//            }else {
//                print("Saved image to database.")
//            }
//        }
//    }
    
    @IBAction func maleAttachmentPressed(_ sender: UIButton) {
        let uiimage = UIImagePickerController()
        uiimage.delegate = self
        
        uiimage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        uiimage.allowsEditing = true
        
        self.present(uiimage, animated: true)
        {
            self.maleImageView.layer.cornerRadius = 75
            self.maleImageView.layer.masksToBounds = true
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
            self.femaleImageView.layer.cornerRadius = 75
            self.femaleImageView.layer.masksToBounds = true
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
    
//    func uploadImg() {
//
//        guard let img = maleImageView.image , imageSelected == true else {
//            print("Image must be selected")
//            return
//        }
//        //Posting data to server
//        func setUpUser() {
//            let userData = [
//                "username": NSUserName(),
//                "userImage": img
//                ] as [String : Any]
//            keyChain()
//            let setLocation = Database.database().reference().child("users").child(userUid)
//            setLocation.setValue(userData)
//        }
//
//        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
//            let imgUid = NSUUID().uuidString
//            let storageReference = Storage().reference().child(imgUid)
//
//            let localFile = URL(string: "path/to/image")!
//            let metaData = StorageMetadata()
//            metaData.contentType = "img/jpeg"
//
//            storageReference.putData(imgData, metadata: metaData)
//
//            storageReference.putFile(from: localFile, metadata: metaData)
//
//           // let downloadURL =
//
//
//
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMaleProfileVC"  {
            let destinationVC = segue.destination as! MaleProfileViewController
            
            if firstNameTextLabel.text != nil {
           
                destinationVC.stringHolder = firstNameTextLabel.text!
                destinationVC.ProfilePic = maleImageView
            }
            
        }  else if segue.identifier == "goToFemaleProfileVC" {
            
            let destinationVC = segue.destination as! FemaleProfileViewController
            destinationVC.stringHolder = firstNameTextLabel.text!
            destinationVC.ForFemaleProfilePic = femaleImageView
            
        }
    }
    
    
}














