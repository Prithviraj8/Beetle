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

    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var maleImageButton: UIButton!
    @IBOutlet weak var femaleImageButton: UIButton!
    @IBOutlet weak var nextMale: UIButtonX!
    
    var passwordTextField : String = ""
    
    var firstNameTextLabel : String = ""
    var emailTextFields : String!
    var gender : String = ""
    var count : Int = 0
    
    let user : [User] = [User]()
    var userUid: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var ref: DatabaseReference!
    var userID = Auth.auth().currentUser?.uid
    var age : Int!
    var messages = message()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        nextMale?.setGradientBackground(colorOne: Colors.brightOrange, colorTwo: Colors.orange)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        maleImageView?.translatesAutoresizingMaskIntoConstraints = false
        maleImageView?.layer.cornerRadius = 10
        femaleImageView?.translatesAutoresizingMaskIntoConstraints = false
        femaleImageButton?.translatesAutoresizingMaskIntoConstraints = false
        maleImageButton?.translatesAutoresizingMaskIntoConstraints = false
        maleImageButton?.layer.masksToBounds = true
        femaleImageButton?.layer.masksToBounds = true
        maleImageView?.layer.masksToBounds = true
        femaleImageView?.layer.masksToBounds = true
        femaleImageView?.layer.cornerRadius = 10
        maleImageButton?.layer.cornerRadius = 10
        femaleImageButton?.layer.cornerRadius = 10
        //uploadImg()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextToProfileVcPressed(_ sender: Any) {
    uploadImageForMale()
    }
    
    func uploadImageForMale() {
        //Saving image to Firebase======================

        let imageName = NSUUID().uuidString
        var storageRef: StorageReference!
       // let data = NSData()
        storageRef = Storage.storage().reference(forURL: "gs://beetle-5b79a.appspot.com/").child("\(imageName).png")

        // let uploadData = StorageMetadata()
        if let uploadData = UIImageJPEGRepresentation((maleImageView?.image!)!, 0.1) {
            
            storageRef.putData(uploadData as Data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error while uploading image : \(String(describing: error?.localizedDescription))")
                } else {
                    print("Successfully saved images to database : \(String(describing: metadata))")
                 
                    storageRef.downloadURL(completion: { (url, err) in

                        if err != nil {

                            print("Error while downloadingURL : \(err?.localizedDescription)")
                            return
                        }
                        let downloadURL = url?.absoluteString
                       // print("The URL of the image is :\(downloadURL)")
                        let values = ["Name ": self.firstNameTextLabel, "Email " : self.emailTextFields, "Profile Pic " : downloadURL!, "Gender " : self.gender, "UserId " : self.userID, "Age ": self.age] as [String : AnyObject]
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
        storageRef = Storage.storage().reference(forURL: "gs://beetle-5b79a.appspot.com/").child("\(imageName).jpg")

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
                        let values = ["Name ": self.firstNameTextLabel, "Email " : self.emailTextFields, "Profile Pic " : downloadURL!, "Gender " : self.gender, "UserId " : self.userID, "Age ": self.age] as [String : AnyObject]
                        self.saveFemaleUserToFirebase(values: values)
                    })

                }
            }
            //return
        }
    }
    
    
    @IBAction func femaleNextToProfileVcPressed(_ sender: Any) {
        
        //Saving image to Firebase
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

//            let imageData = UIImagePNGRepresentation(uiimage)
            let imageData = UIImageJPEGRepresentation(uiimage, 0.1)
            maleImageView?.image = uiimage
            femaleImageView?.image = uiimage
        } else {
          //Print error
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func saveMaleUserToFirebase(values: [String: AnyObject]) {
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
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
        ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/")
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
                destinationVC.userID = userID!
                destinationVC.age = age
              }

        }  else if segue.identifier == "goToFemaleProfileVC" {

            let destinationVC = segue.destination as! FemaleProfileViewController

            if firstNameTextLabel != nil {
                
                destinationVC.count = count
                destinationVC.stringHolder = firstNameTextLabel
                destinationVC.femaleProfilePicImage = femaleImageView?.image
                destinationVC.userID = userID!
                
 
            }
        }
    }

    
    
}














