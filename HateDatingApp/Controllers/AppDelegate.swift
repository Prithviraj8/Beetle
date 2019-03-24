//
//  AppDelegate.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 18/06/18.
//  Copyright © 2018 Prithviraj Murthy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import UserNotifications
import GoogleSignIn

//import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,GIDSignInUIDelegate {
    

    var window: UIWindow?
    var notificationPublisher = NotificationPublisher()
    var messages = message()
    var SignInInfo = SingInInfo()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        /* We've commented the two lines below becasue they were just a testing message to see if the messages is saved in the firbase.But when we logout of the app and re run it the chat history is wiped from both the iphone and the firebase database.  */
        //        let myDatabase = Database.database().reference()
        //        myDatabase.setValue("We've got data")

//        func userNotification(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void ){
//            completionHandler([.alert, .sound])
//
//        }
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            print("Granted \(granted)")

        }
        
        func userNotificationCenter(_center: UNUserNotificationCenter, didReceive responce: UNNotificationResponse, withCompletionHandler completionHandler: @escaping() -> Void ) {
            if responce.notification.request.identifier == "testIdentifier" {
                print("Handling notification with the identifier 'testIdentifier ' ")
            }
            completionHandler()
        }
        
        
  
        
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            print("Granted \(granted)")
//        }
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "620661805649-jthc2n6je1rid5f85g17iko2cq58in1s.apps.googleusercontent.com"
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        var fnames = [String]()
        var count = 1
        print("Resigning")
        if Auth.auth().currentUser?.uid != nil {

            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((Auth.auth().currentUser?.uid)!)
            ref.observeSingleEvent(of: .value) { (snap1) in
                //                if snap1.key == Auth.auth().currentUser?.uid {
                //                    childRef.observeSingleEvent(of: .value) { (snap) in
                if let snapshotValue = snap1.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(name)
                    var ReceivedMessageTime = [Double]()
                    
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
//                            let snapshotValue = snapshot.value as! NSDictionary
                            for femaleNames in snapshot.children {
                                let fname = femaleNames as! DataSnapshot
                                fnames.append(fname.key)
                                let fid = snapshot.key
                                let NAME = fname.key
                                print("FNAMES \(fname.key)")
                                
                                //                    for messages in fname.children {
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        
                                        
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        
                                        if messageRead == "False" {
                                            if notified == "False" {
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                count = count + 1
                                                print("NOTIFIED IN ACTIVE\(notified)")
                                            }
                                        }
                                        
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                                //                    }
                            }
                        }
                    }
                }
            }
                    //Female side notification displayer
                    let female_ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child((Auth.auth().currentUser?.uid)!)

                    female_ref.observeSingleEvent(of: .value) { (snap) in

                        if let snapshotValue = snap.value as? NSDictionary {
                            let name = snapshotValue["Name "] as! String
                            let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(name)


                            var ReceivedMessageTime = [Double]()

                            messageDB.observeSingleEvent(of: .value) { (snap1) in
                                messageDB.observe(.childAdded) { (snapshot) in

                                    for maleNames in snapshot.children {
                                        print("FIDS \(snapshot.key)")
                                        let Mname = maleNames as! DataSnapshot
                                        fnames.append(Mname.key)
                                        let fid = snapshot.key
                                        let NAME = Mname.key

                                        let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                        ref2.observe(.childAdded, with: { (message) in
                                            let snapshotValue1 = message.value as! NSDictionary

                                            if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {


                                                let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                                ReceivedMessageTime.append(messageTimeStamp)
                                                let currentTimeStamp = NSDate().timeIntervalSince1970

                                                let messageRead = snapshotValue1["Message Read "] as! String
                                                let notified = snapshotValue1["Message Notified "] as! String

                                                if messageRead == "False" {
                                                    if notified == "False" {
                                                    self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                    self.notificationPublisher.name = NAME
//                                                    print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                    ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                        count = count + 1
                                                        print("NOTIFIED IN ACTIVE \(notified)")

                                                  }
                                                    
                                                }
                                            }else{
                                                print("NO MESSAGEE")
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("We are in background \(String(describing: Auth.auth().currentUser?.uid))")
        var fnames = [String]()
        var count = 1
        
        if Auth.auth().currentUser?.uid != nil {
            
            
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((Auth.auth().currentUser?.uid)!)
            ref.observeSingleEvent(of: .value) { (snap1) in
//                if snap1.key == Auth.auth().currentUser?.uid {
                    let childRef = ref.child(snap1.key)
//                    childRef.observeSingleEvent(of: .value) { (snap) in
                if let snapshotValue = snap1.value as? NSDictionary {
                        let name = snapshotValue["Name "] as! String
                        
                        let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(name)
                        var ReceivedMessageTime = [Double]()
                        
                        
                        messageDB.observeSingleEvent(of: .value) { (snap1) in
                            messageDB.observe(.childAdded) { (snapshot) in
                                
                                let snapshotValue = snapshot.value as! NSDictionary
                                for femaleNames in snapshot.children {
                                    let fname = femaleNames as! DataSnapshot
                                    fnames.append(fname.key)
                                    let fid = snapshot.key
                                    let NAME = fname.key
                                    
                                    //                    for messages in fname.children {
                                    let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                    ref2.observe(.childAdded, with: { (message) in
                                        let snapshotValue1 = message.value as! NSDictionary
                                        
                                        if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                            
                                            
                                            let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                            ReceivedMessageTime.append(messageTimeStamp)
                                            let currentTimeStamp = NSDate().timeIntervalSince1970
                                            let myTimeInterval = TimeInterval(currentTimeStamp)
                                   
                                            
                                            let messageRead = snapshotValue1["Message Read "] as! String
                                            let notified = snapshotValue1["Message Notified "] as! String

                                            if messageRead == "False" {
                                                if notified == "False" {
                                                    self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                    self.notificationPublisher.name = NAME
                                                    print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                    ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                    print("NOTIFIED IN BACK \(notified)")

                                                    count = count + 1

                                                }
                                            }
                                     
                                        }else{
                                            print("NO MESSAGEE")
                                        }
                                    })
                                    //                    }
                                }
                            }
                    }
                }
            }
//                    }
//                }else{
                    //Female side notification displayer
                    let female_ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child((Auth.auth().currentUser?.uid)!)
                    
                    female_ref.observeSingleEvent(of: .value) { (snap) in
                        
                        if let snapshotValue = snap.value as? NSDictionary {
                            let name = snapshotValue["Name "] as! String
                            let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(name)
                            print("LOG USER \(Auth.auth().currentUser?.email)")

                            
                            var ReceivedMessageTime = [Double]()
                            
                            messageDB.observeSingleEvent(of: .value) { (snap1) in
                                messageDB.observe(.childAdded) { (snapshot) in
                                    
                                    let snapshotValue = snapshot.value as! NSDictionary
                                    for maleNames in snapshot.children {
                                        print("FIDS \(snapshot.key)")
                                        let Mname = maleNames as! DataSnapshot
                                        fnames.append(Mname.key)
                                        let fid = snapshot.key
                                        let NAME = Mname.key
                                        print("FNAME AND IDS ARE \(fid) , \(NAME)")
                                        
                                        let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                        ref2.observe(.childAdded, with: { (message) in
                                            let snapshotValue1 = message.value as! NSDictionary
                                            
                                            if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                                
                                                
                                                let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                                ReceivedMessageTime.append(messageTimeStamp)
                                                let currentTimeStamp = NSDate().timeIntervalSince1970
                                                let myTimeInterval = TimeInterval(currentTimeStamp)
                                                
                                                // print("TIME IS  \(currentTimeStamp),  \(ReceivedMessageTime.last!)")
                                                let messageRead = snapshotValue1["Message Read "] as! String
                                                let notified = snapshotValue1["Message Notified "] as! String
                                                if messageRead == "False"{
                                                    if notified == "False" {
                                                        
                                                        self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                        self.notificationPublisher.name = NAME
                                                        print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                        ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                        count = count + 1
                                                        print("NOTIFIED IN BACK \(notified)")

                                                    }
                                                    
                                                }
                                            }else{
                                                print("NO MESSAGEE")
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
//                }
//            }
        }
        
        
}

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("IN FOREGROUND")
        var fnames = [String]()
        var count = 1
        if Auth.auth().currentUser?.uid != nil {
            
            
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((Auth.auth().currentUser?.uid)!)
            ref.observeSingleEvent(of: .value) { (snap1) in
                //                if snap1.key == Auth.auth().currentUser?.uid {
                //                    childRef.observeSingleEvent(of: .value) { (snap) in
                if let snapshotValue = snap1.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(name)
                    var ReceivedMessageTime = [Double]()
                    
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            for femaleNames in snapshot.children {
                                let fname = femaleNames as! DataSnapshot
                                fnames.append(fname.key)
                                let fid = snapshot.key
                                let NAME = fname.key
                                
                                //                    for messages in fname.children {
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        
                                        
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        
                                        if messageRead == "False" {
                                            if notified == "False" {
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                print("NOTIFIED IN FORE \(notified)")

                                                count = count + 1
                                                
                                            }
                                        }
                                        
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                                //                    }
                            }
                        }
                    }
                }
            }
            //                    }
            //                }else{
            //Female side notification displayer
            let female_ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child((Auth.auth().currentUser?.uid)!)
            
            female_ref.observeSingleEvent(of: .value) { (snap) in
                
                if let snapshotValue = snap.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(name)
                    print("LOG USER \(String(describing: Auth.auth().currentUser?.email))")
                    
                    
                    var ReceivedMessageTime = [Double]()
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            for maleNames in snapshot.children {
                                print("FIDS \(snapshot.key)")
                                let Mname = maleNames as! DataSnapshot
                                fnames.append(Mname.key)
                                let fid = snapshot.key
                                let NAME = Mname.key
                                print("FNAME AND IDS ARE \(fid) , \(NAME)")
                                
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        
                                        // print("TIME IS  \(currentTimeStamp),  \(ReceivedMessageTime.last!)")
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        if messageRead == "False"{
                                            if notified == "False" {
                                                
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                count = count + 1
                                                print("NOTIFIED IN FORE \(notified)")
                                                
                                            }
                                            
                                        }
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                            }
                        }
                    }
                }
            }
            //                }
            //            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("ACTIVE")
    
        var fnames = [String]()
        var Mnames = [String]()
        var count = 1
        if Auth.auth().currentUser?.uid != nil {
            
            
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((Auth.auth().currentUser?.uid)!)
            ref.observeSingleEvent(of: .value) { (snap1) in
                //                if snap1.key == Auth.auth().currentUser?.uid {
                let childRef = ref.child(snap1.key)
                //                    childRef.observeSingleEvent(of: .value) { (snap) in
                if let snapshotValue = snap1.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(name)
                    var ReceivedMessageTime = [Double]()
                    
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            let snapshotValue = snapshot.value as! NSDictionary
                            for femaleNames in snapshot.children {
                                let fname = femaleNames as! DataSnapshot
                                fnames.append(fname.key)
                                let fid = snapshot.key
                                let NAME = fname.key
                                
                                //                    for messages in fname.children {
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        let myTimeInterval = TimeInterval(currentTimeStamp)
                                        
                                        
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        
                                        if messageRead == "False" {
                                            if notified == "False" {
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                print("NOTIFIED IN ACTIVE \(notified)")

                                                count = count + 1
                                                
                                            }
                                        }
                                        
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                                //                    }
                            }
                        }
                    }
                }
            }
            //                    }
            //                }else{
            //Female side notification displayer
            let female_ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child((Auth.auth().currentUser?.uid)!)
            
            female_ref.observeSingleEvent(of: .value) { (snap) in
                
                if let snapshotValue = snap.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(name)
                    print("LOG USER \(Auth.auth().currentUser?.email)")
                    
                    
                    var ReceivedMessageTime = [Double]()
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            let snapshotValue = snapshot.value as! NSDictionary
                            for maleNames in snapshot.children {
                                print("FIDS \(snapshot.key)")
                                let Mname = maleNames as! DataSnapshot
                                fnames.append(Mname.key)
                                let fid = snapshot.key
                                let NAME = Mname.key
                                print("FNAME AND IDS ARE \(fid) , \(NAME)")
                                
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        let myTimeInterval = TimeInterval(currentTimeStamp)
                                        
                                        // print("TIME IS  \(currentTimeStamp),  \(ReceivedMessageTime.last!)")
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        if messageRead == "False"{
                                            if notified == "False" {
                                                
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                count = count + 1
                                                print("NOTIFIED IN ACTIVE \(notified)")
                                                
                                            }
                                            
                                        }
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                            }
                        }
                    }
                }
            }
            //                }
            //            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("Terminated app")
        var fnames = [String]()
        var Mnames = [String]()
        var count = 1
        if Auth.auth().currentUser?.uid != nil {
            
            
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((Auth.auth().currentUser?.uid)!)
            ref.observeSingleEvent(of: .value) { (snap1) in
                //                if snap1.key == Auth.auth().currentUser?.uid {
                let childRef = ref.child(snap1.key)
                //                    childRef.observeSingleEvent(of: .value) { (snap) in
                if let snapshotValue = snap1.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(name)
                    var ReceivedMessageTime = [Double]()
                    
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            let snapshotValue = snapshot.value as! NSDictionary
                            for femaleNames in snapshot.children {
                                let fname = femaleNames as! DataSnapshot
                                fnames.append(fname.key)
                                let fid = snapshot.key
                                let NAME = fname.key
                                
                                //                    for messages in fname.children {
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        let myTimeInterval = TimeInterval(currentTimeStamp)
                                        
                                        
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        
                                        if messageRead == "False" {
                                            if notified == "False" {
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                print("NOTIFIED AFTER TERMINATION \(notified)")

                                                count = count + 1
                                                
                                            }
                                        }
                                        
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                                //                    }
                            }
                        }
                    }
                }
            }
            //                    }
            //                }else{
            //Female side notification displayer
            let female_ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child((Auth.auth().currentUser?.uid)!)
            
            female_ref.observeSingleEvent(of: .value) { (snap) in
                
                if let snapshotValue = snap.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(name)
                    print("LOG USER \(Auth.auth().currentUser?.email)")
                    
                    
                    var ReceivedMessageTime = [Double]()
                    
                    messageDB.observeSingleEvent(of: .value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            let snapshotValue = snapshot.value as! NSDictionary
                            for maleNames in snapshot.children {
                                print("FIDS \(snapshot.key)")
                                let Mname = maleNames as! DataSnapshot
                                fnames.append(Mname.key)
                                let fid = snapshot.key
                                let NAME = Mname.key
                                print("FNAME AND IDS ARE \(fid) , \(NAME)")
                                
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                ref2.observe(.childAdded, with: { (message) in
                                    let snapshotValue1 = message.value as! NSDictionary
                                    
                                    if let ReceivedMessage = snapshotValue1["ReceivedMessage "] {
                                        
                                        
                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                        ReceivedMessageTime.append(messageTimeStamp)
                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                        let myTimeInterval = TimeInterval(currentTimeStamp)
                                        
                                        // print("TIME IS  \(currentTimeStamp),  \(ReceivedMessageTime.last!)")
                                        let messageRead = snapshotValue1["Message Read "] as! String
                                        let notified = snapshotValue1["Message Notified "] as! String
                                        if messageRead == "False"{
                                            if notified == "False" {
                                                
                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage as! String, badge: count, delayInterval: 1)
                                                self.notificationPublisher.name = NAME
                                                print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                count = count + 1
                                                print("NOTIFIED AFTER TERMINATION \(notified)")
                                                
                                            }
                                            
                                        }
                                    }else{
                                        print("NO MESSAGEE")
                                    }
                                })
                            }
                        }
                    }
                }
            }
          
        }
        
    }


}

