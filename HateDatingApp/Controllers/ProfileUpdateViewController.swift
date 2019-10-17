//
//  ProfileUpdateViewController.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 10/04/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileUpdateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var mainProfilePic: UIImageViewX!
    @IBOutlet weak var ProfilePic2: UIImageViewX!
    @IBOutlet weak var ProfilePic3: UIImageViewX!
    @IBOutlet weak var ProfilePic4: UIImageViewX!
    
    @IBOutlet weak var NextButton: UIButtonX!
    @IBOutlet weak var topView: UIView!

    
    var userId = Auth.auth().currentUser?.uid
    var firstNametextLable : String!
    var CurrentUserGender : String!
    var gender : String!
    var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()
//        user.CurrentUserGender = CurrentUserGender

        // Do any additional setup after loading the view.
    
        mainProfilePic?.translatesAutoresizingMaskIntoConstraints = false
        mainProfilePic?.layer.masksToBounds = true
        
//        mainProfilePic.layer.cornerRadius = 24
//        mainProfilePic.layer.borderWidth = 3
//        mainProfilePic.layer.borderColor = UIColor.lightGray.cgColor
//
        ProfilePic2?.translatesAutoresizingMaskIntoConstraints = false
        ProfilePic2?.layer.masksToBounds = true
//        ProfilePic2.layer.cornerRadius = 24
//        ProfilePic2.layer.borderWidth = 3
//        ProfilePic2.layer.borderColor = UIColor.lightGray.cgColor

        ProfilePic3?.translatesAutoresizingMaskIntoConstraints = false
        ProfilePic3?.layer.masksToBounds = true
//        ProfilePic3.layer.cornerRadius = 24
//        ProfilePic3.layer.borderWidth = 3
//        ProfilePic3.layer.borderColor = UIColor.lightGray.cgColor

        ProfilePic4?.translatesAutoresizingMaskIntoConstraints = false
        ProfilePic4?.layer.masksToBounds = true
//        ProfilePic4.layer.cornerRadius = 24
//        ProfilePic4.layer.borderWidth = 3
//        ProfilePic4.layer.borderColor = UIColor.lightGray.cgColor

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (ProfilePic2Tapped(gesture:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector (ProfilePic3Tapped(gesture:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector (ProfilePic4Tapped(gesture:)))

        ProfilePic2?.addGestureRecognizer(tapGesture)
        ProfilePic3?.addGestureRecognizer(tapGesture2)
        ProfilePic4?.addGestureRecognizer(tapGesture3)

//        NextButton?.translatesAutoresizingMaskIntoConstraints = false
//        NextButton?.layer.masksToBounds = true
        NextButton?.setGradientBackground(colorOne: Colors.brightOrange, colorTwo: Colors.lightPink)
        
        
        uploadImage()
        topView?.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.lightPink)
//        let ratio = mainProfilePic.frame.width/mainProfilePic.frame.height
//        print("MAIN PIC VIEW RATIO \(ratio)")

        
    }
    
    func uploadImage(){

        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(CurrentUserGender).child(self.userId!)

        ref.observe(.value) { (snap) in
            if let value = snap.value as? NSDictionary {
                if let mainPic = value["Profile Pic "] as? String {
                    if let url = URL(string: mainPic){
                        
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                                //                            print("Failed while fetching images : \(error?.localizedDescription)")
                                return
                            }else {
                                DispatchQueue.main.async {
                                    let image = UIImage(data: data!)
                                    let width : CGFloat = (image?.size.width)!
                                    let height : CGFloat = (image?.size.height)!
                                    let ratio = width/height
                                    print("MAIN PIC RATIO \(ratio)")

                                    self.mainProfilePic?.image = UIImage(data: data!)
                                    SVProgressHUD.dismiss()
                                }
                            }
                            
                        }).resume()
                    }
                }
                if let extraPic = value["Extra pic2 "] as? String {
                    SVProgressHUD.show()
                    if let url = URL(string: extraPic){
                        
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                                //                            print("Failed while fetching images : \(error?.localizedDescription)")
                                return
                            }else {
                                DispatchQueue.main.async {
                                    self.ProfilePic2?.image = UIImage(data: data!)
                                    SVProgressHUD.dismiss()
                                }
                            }
                            
                        }).resume()
                    }
                }
                
                if let extraPic = value["Extra pic3 "] as? String {
                    SVProgressHUD.show()
                    if let url = URL(string: extraPic){
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                                //                            print("Failed while fetching images : \(error?.localizedDescription)")
                                return
                            }else {
                                DispatchQueue.main.async {
                                    self.ProfilePic3?.image = UIImage(data: data!)
                                    SVProgressHUD.dismiss()
                                }
                            }
                            
                        }).resume()
                    }
                }
                
                if let extraPic = value["Extra pic4 "] as? String {
                    SVProgressHUD.show()

                    if let url = URL(string: extraPic){
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            if error != nil {
                                //                            print("Failed while fetching images : \(error?.localizedDescription)")
                                return
                            }else {
                                DispatchQueue.main.async {
                                    self.ProfilePic4?.image = UIImage(data: data!)
                                    SVProgressHUD.dismiss()
                                }
                            }
                            
                        }).resume()
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    @objc func ProfilePic2Tapped(gesture: UIGestureRecognizer){
        user.imageTapped = "ProfilePic2"
        print("IMAGE 2 ")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
    }
    @objc func ProfilePic3Tapped(gesture: UIGestureRecognizer){
        user.imageTapped = "ProfilePic3"
        print("IMAGE 3 ")

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
    }
    @objc func ProfilePic4Tapped(gesture: UIGestureRecognizer){
        user.imageTapped = "ProfilePic4"
        print("IMAGE 4 ")

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker = UIImage()
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker as? UIImage {
            uploadImageToFirebase(image: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebase(image: UIImage){
        let imageName = NSUUID().uuidString
        var storageRef: StorageReference!
        // let data = NSData()
        storageRef = Storage.storage().reference(forURL: "gs://beetle-5b79a.appspot.com/").child("images_sent").child("\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            
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
                        
                        
                        let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child(self.CurrentUserGender).child(self.userId!)
                        if self.user.imageTapped == "ProfilePic2" {
                            ref.updateChildValues(["Extra pic2 ": downloadURL])
                        }else if self.user.imageTapped == "ProfilePic3" {
                            ref.updateChildValues(["Extra pic3 ": downloadURL])


                        }else if self.user.imageTapped == "ProfilePic4" {
                            ref.updateChildValues(["Extra pic4 ": downloadURL])


                        }
                    
                    })
                    
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "descriptionSegue"{
            let VC = segue.destination as? UserDescriptionVC
            VC?.firstNametextLable = firstNametextLable
            VC?.CurrentUserGender = CurrentUserGender
        }
    }
    
}

