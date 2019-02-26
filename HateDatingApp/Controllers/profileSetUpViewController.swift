//
//  profileSetUpViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 27/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
//import ChameleonFramework
import SDWebImage
import MobileCoreServices
import AVKit
import SwiftKeychainWrapper
import FirebaseStorage
//import FirebaseDatabase

class profileSetUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var maleImageView: UIImageViewX?
    @IBOutlet weak var femaleImageView: UIImageViewX?
    
    var firstNameTextLabel : String = ""
    var emailTextFields : String = ""
    var gender : String = ""
    var count : Int = 0
    
    let user : [User] = [User]()
    var userUid: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid

    
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
        

        //let username = firstNameTextLabel.text!
        //uploadData.contentType = "image/jpeg"
      
//        storageRef.putData(data as Data, metadata: uploadData) { (metadata, error) in
//            if error != nil {
//                print("Error while uploading image : \(String(describing: error?.localizedDescription))")
//            } else {
//                print("Successfully saved images to database : \(String(describing: metadata))")
//               // let size = metadata?.size
//
//                self.ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
//                let usersChildRef = self.ref.child("users").childByAutoId()
//                let values = ["Name " : self.maleImageView , "Email " : self.emailTextField, "Profile Pic " : metadata!] as [String : Any]
//
//                usersChildRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
//
//                    if error != nil {
//                        print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
//                    } else {
//                        print("Successfully saving information of the user.")
//                    }
//                })
//                //Download URL of image
//                storageRef.downloadURL(completion: { (url, err) in
//                    guard let downloadURL = url else {
//                        print("Error \(err?.localizedDescription)")
//                     //   let values = ["Name " : self.firstNameTextLabel , "Email " : self.emailTextField, "Profile Pic " : url!] as [String : Any]
//                     //   self.saveInfoOfUserToFirebase(values: values)
//
//                        return
//                    }
//                })
//
//            }
//        }
        
        
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
    uploadImageForMale()
    }
    
    func uploadImageForMale() {
        //Saving image to Firebase======================

        let imageName = NSUUID().uuidString
        var storageRef: StorageReference!
       // let data = NSData()
        storageRef = Storage.storage().reference(forURL: "gs://hatedateapp-ea81a.appspot.com").child("\(imageName).png")

        // let uploadData = StorageMetadata()
        if let uploadData = UIImageJPEGRepresentation((maleImageView?.image!)!, 0.1) {
            
            storageRef.putData(uploadData as Data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error while uploading image : \(String(describing: error?.localizedDescription))")
                } else {
                    print("Successfully saved images to database : \(String(describing: metadata))")
                    // let size = metadata?.size
                    //

                    //Download URL of image
                    storageRef.downloadURL(completion: { (url, err) in

                        if err != nil {

                            print("Error while downloadingURL : \(err?.localizedDescription)")
                            return
                        }
                        let downloadURL = url?.absoluteString
                       // print("The URL of the image is :\(downloadURL)")
                        let values = ["Name ": self.firstNameTextLabel, "Email " : self.emailTextFields, "Profile Pic " : downloadURL!, "Gender " : self.gender, "UserId " : self.userID] as [String : AnyObject]
                        self.saveMaleUserToFirebase(values: values)
                    })

                }
            }
            //return
        }
    }

    func uploadImageForFemale() {
        //Saving image to Firebase======================

        let imageName = NSUUID().uuidString
        var storageRef: StorageReference!
        // let data = NSData()
        storageRef = Storage.storage().reference(forURL: "gs://hatedateapp-ea81a.appspot.com").child("\(imageName).jpg")

        // let uploadData = StorageMetadata()

        if let uploadData = UIImageJPEGRepresentation((femaleImageView?.image)!, 0.1) {
//        if let uploadData = UIImagePNGRepresentation((femaleImageView?.image)!) {

            storageRef.putData(uploadData as Data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error while uploading image : \(String(describing: error?.localizedDescription))")
                } else {
                    print("Successfully saved images to database : \(String(describing: metadata))")
                    // let size = metadata?.size
                    //
                
                    //Download URL of image
                    storageRef.downloadURL(completion: { (url, err) in

                        if err != nil {

                            print("Error while downloadingURL : \(err?.localizedDescription)")
                            return
                        }
                        let downloadURL = url?.absoluteString
                        print("The URL of the image is :\(downloadURL)")
                        let values = ["Name ": self.firstNameTextLabel, "Email " : self.emailTextFields, "Profile Pic " : downloadURL!, "Gender " : self.gender, "UserId " : self.userID] as [String : AnyObject]
                        self.saveFemaleUserToFirebase(values: values)
                    })

                }
            }
            //return
        }
    }
    
    
    @IBAction func femaleNextToProfileVcPressed(_ sender: Any) {
        
        //Saving image to Firebase
//
//        let data = NSData()
//       // let imageName = NSUUID().uuidString
//        let username = firstNameTextLabel
//
//        let storageRef = Storage.storage().reference(withPath: "\(firstNameTextLabel).png/Female Image")
//        let uploadData = StorageMetadata()
//        uploadData.contentType = "image/jpeg"
//
//        storageRef.putData(data as Data, metadata: uploadData) { (metadata, error) in
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                print("Successfully Image saved to firebase \(String(describing: metadata))")
//                
//                
//                //let size = metadata?.size
//                
//                storageRef.downloadURL(completion: { (url, err) in
//                    guard let downloadURL = url else {
//                        print("Error \(err?.localizedDescription)")
//                        return
//                    }
//            //self.performSegue(withIdentifier: "goToFemaleProfileVC", sender: self)
//
//            })
//        }
//  }
    uploadImageForFemale()
}
 

    
   


    @IBAction func maleAttachmentPressed(_ sender: UIButton) {
        let uiimage = UIImagePickerController()
        uiimage.delegate = self
        
        uiimage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        uiimage.allowsEditing = true
        present(uiimage, animated: true, completion: nil)
        self.present(uiimage, animated: true)
        {
            self.maleImageView?.layer.cornerRadius = 10
            self.maleImageView?.layer.masksToBounds = true
            //Code after it is completed
            
        }
    }
    
 
    
        
    
    
    
    
    @IBAction func femaleAttachmentPressed(_ sender: UIButton) {
        
        let uiimage = UIImagePickerController()
        uiimage.delegate = self
        
        uiimage.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        uiimage.allowsEditing = true
        present(uiimage, animated: true, completion: nil)
        self.present(uiimage, animated: true)
        {
            self.femaleImageView?.layer.cornerRadius = 10
            self.femaleImageView?.layer.masksToBounds = true
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {


        if let uiimage = info[UIImagePickerControllerOriginalImage] as? UIImage {

                let imageData = UIImagePNGRepresentation(uiimage)
            
           
            
            maleImageView?.image = uiimage
            femaleImageView?.image = uiimage
             //  uploadImageForMale(data: imageData as! NSData)




        } else {
          //Print error
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func saveMaleUserToFirebase(values: [String: AnyObject]) {
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
        let usersChildRef = ref.child("users").child("Male").child(userID!)
        
        
        usersChildRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
            } else {
                print("Successfully saving information of the user.")
                self.count += 1
            }
        }

    }

    func saveFemaleUserToFirebase(values: [String: AnyObject]) {
        ref = Database.database().reference(fromURL: "https://hatedateapp-ea81a.firebaseio.com/")
        let usersChildRef = ref.child("users").child("Female").child(userID!)
     

        usersChildRef.updateChildValues(values) { (error, ref) in

            if error != nil {
                print("ERROR WHILE SAVING information of user : \(error?.localizedDescription)")
            } else {
                print("Successfully saving information of the user.")
                self.count += 1
            }
       
        }

    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMaleProfileVC"  {
            let destinationVC = segue.destination as! MaleProfileViewController

              if firstNameTextLabel != nil {

                destinationVC.count = count
                destinationVC.stringHolder = firstNameTextLabel
                destinationVC.MaleProfilPicImage = maleImageView?.image
               // destinationVC.userID = userID!
              }

        }  else if segue.identifier == "goToFemaleProfileVC" {

            let destinationVC = segue.destination as! FemaleProfileViewController

            if firstNameTextLabel != nil {
                
                destinationVC.count = count
                destinationVC.stringHolder = firstNameTextLabel
                destinationVC.femaleProfilePicImage = femaleImageView?.image
                //destinationVC.userID = userID!

 
            }
        }
    }

    
    
}














