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
        
        //application.setMinimumBackgroundFetchInterval(1800)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

       
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
    
//    
//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
////        guard let data = newMessageNotification else {
////            // data download failed
////            completionHandler(.failed)
////            return
////        }
////
////        if data.isNew {
////            // data download succeeded and is new
////            completionHandler(.newData)
////        } else {
////            // data downloaded succeeded and is not new
////            completionHandler(.noData)
////        }
//    }
 
    func newMessageNotification(){
        
        
        var fnames = [String]()
        var count = 1
        if Auth.auth().currentUser?.uid != nil {
            
            let ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Male").child((Auth.auth().currentUser?.uid)!)
            ref.observe(.value) { (snap1) in
                //                if snap1.key == Auth.auth().currentUser?.uid {
                //                    childRef.observeSingleEvent(of: .value) { (snap) in
                if let snapshotValue = snap1.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Male").child((Auth.auth().currentUser?.uid)!).child(name)
                    var ReceivedMessageTime = [Double]()
                    
                    
//                    messageDB.observe(.value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            //                            let snapshotValue = snapshot.value as! NSDictionary
                            for femaleNames in snapshot.children {
                                let fname = femaleNames as! DataSnapshot
                                fnames.append(fname.key)
                                let fid = snapshot.key
                                let NAME = fname.key
                                print("FNAMES \(fname.key)")
                                
                            if NAME != "Badge " || NAME != "Badge added " || NAME != "Pressed " {
                                let ref2 = messageDB.child(fid).child(NAME).child("Messages")
                                let ref3 = messageDB.child(fid).child(NAME)
                                ref3.observe(.childAdded, with: { (snap) in
                                    if let value = snap.value as? NSDictionary {
                                    if let inMessageVC = value["In Message VC "] as? Bool {
                                        print("IN MESSAGE VC \(inMessageVC)")

                                        let state = UIApplication.shared.applicationState
//                                        if state == .background  || state == .inactive{
//                                            ref3.updateChildValues(["In Message VC ": "False "])
//                                        }
                                        
                                        
                                        if inMessageVC == false {
                                            ref2.observe(.childAdded, with: { (message) in
                                                if let snapshotValue1 = message.value as? NSDictionary {
                                                    print("WE ARE IN NOTIFICATION FUNC")
                                                    let fromId = snapshotValue1["fromId"] as? String
                                                    if fromId != Auth.auth().currentUser?.uid {
                                                        if let ReceivedMessage = snapshotValue1["text "] as? String {
//                                                        print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")

                                                        let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
                                                        ReceivedMessageTime.append(messageTimeStamp)
                                                        let currentTimeStamp = NSDate().timeIntervalSince1970
                                                        
                                                        
                                                        let messageRead = snapshotValue1["Message Read "] as! Bool
                                                            if let notified = snapshotValue1["Message Notified "] as? Bool{
                                                        
                                                        if messageRead == false {
                                                            if notified == false {
                                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage , badge: count, delayInterval: 1)
                                                                self.notificationPublisher.name = NAME
                                                                self.notificationPublisher.firstNametextLable = name
                                                                self.notificationPublisher.id = snapshot.key
                                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                                count = count + 1
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                            
                                                }else if let imageUrl = snapshotValue1["ImageUrl"] as? String {
                                                            print("NO TEXT MESSAGEE")
                                                            
                                                        if let messageRead = snapshotValue1["Message Read "] as? Bool {
                                                            if  let notified = snapshotValue1["Message Notified "] as? Bool {
                                                            
                                                            
                                                            if messageRead == false {
                                                                if notified == false {
                                                                    self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: "Media received. Check Messages", badge: count, delayInterval: 3)
                                                                    self.notificationPublisher.name = NAME
                                                                    self.notificationPublisher.firstNametextLable = name
                                                                    self.notificationPublisher.id = snapshot.key
                                                                    ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                                    count = count + 1
                                                                    
                                                                }
                                                                }
                                                                
                                                            }
                                                            
                                                            }
                                                        }else if let videoUrl = snapshotValue1["videoUrl"] as? String {
                                                            let messageRead = snapshotValue1["Message Read "] as! Bool
                                                            let notified = snapshotValue1["Message Notified "] as! Bool
                                                            
                                                            
                                                            if messageRead == false {
                                                                if notified == false {
                                                                    self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: "Media received. Check Messages", badge: count, delayInterval: 3)
                                                                    self.notificationPublisher.name = NAME
                                                                    self.notificationPublisher.firstNametextLable = name
                                                                    self.notificationPublisher.id = snapshot.key
                                                                    ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                                    count = count + 1
                                                                    
                                                                }
                                                            }
                                                        }
                                                    
                                                    }
                                                    
                                                }
                                            })
                                        }
                                    }
                                        
                                    }
                                })
                                
                                }
                                
                            }
                        }
                }
            }
            //Female side notification displayer
            let female_ref = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Female").child((Auth.auth().currentUser?.uid)!)
            
            female_ref.observe( .value) { (snap) in
                
                if let snapshotValue = snap.value as? NSDictionary {
                    let name = snapshotValue["Name "] as! String
                    let messageDB = Database.database().reference(fromURL: "https://beetle-5b79a.firebaseio.com/").child("users").child("Match").child("Female").child((Auth.auth().currentUser?.uid)!).child(name)
                    
                    
                    var ReceivedMessageTime = [Double]()
                    
//                    messageDB.observe(.value) { (snap1) in
                        messageDB.observe(.childAdded) { (snapshot) in
                            
                            for maleNames in snapshot.children {
                                let Mname = maleNames as! DataSnapshot
                                fnames.append(Mname.key)
                                let mid = snapshot.key
                                let NAME = Mname.key

                                if NAME != "Badge " || NAME != "Badge added " || NAME != "Pressed " {
                                    print("MNAMES \(NAME)")
                                let ref2 = messageDB.child(mid).child(NAME).child("Messages")
                                let ref3 = messageDB.child(mid).child(NAME)
                                   
                                    let state = UIApplication.shared.applicationState
//                                    if state == .background  || state == .inactive{
//                                        ref3.updateChildValues(["In Message VC ": "False "])
//                                    }
                                    
                                    
                                    ref3.observe(.childAdded, with: { (snap) in
                                    if let value = snap.value as? NSDictionary {
                                        if let inMessageVC = value["In Message VC "] as? Bool {
                                            
                                            if inMessageVC == false {
                                            ref2.observe(.childAdded, with: { (message) in
                                                let snapshotValue1 = message.value as! NSDictionary
                                                print("WE ARE IN NOTIFY CODE")
                                                
                                                let fromId = snapshotValue1["fromId"] as? String

                                                if fromId != Auth.auth().currentUser?.uid {
                                                    if let ReceivedMessage = snapshotValue1["text "] as? String {
//                                                        print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")

//                                                    let messageTimeStamp = snapshotValue1["Time Stamp Received "] as! Double
//                                                    ReceivedMessageTime.append(messageTimeStamp)
//                                                    let currentTimeStamp = NSDate().timeIntervalSince1970
                                                    
                                                    let messageRead = snapshotValue1["Message Read "] as! Bool
                                                        if let notified = snapshotValue1["Message Notified "] as? Bool {
                                                        print("WE ARE IN NOTIFY CODE")

                                                    
                                                    if messageRead == false {
                                                        if notified == false {
                                                            self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: ReceivedMessage, badge: count, delayInterval: 3)
                                                            self.notificationPublisher.name = NAME
                                                            self.notificationPublisher.firstNametextLable = name
                                                            self.notificationPublisher.id = snapshot.key
                                                            print("UNREAD RECEIVED MESSAGE IS \(ReceivedMessage)")
                                                            ref2.child(message.key).updateChildValues(["Message Notified ": "True"])

                                                            count = count + 1
                                                            print("NOTIFIED IN ACTIVE \(notified)")
                                                            
                                                        }
                                                    }
                                                }
                                                        
                                                }else if let imageUrl = snapshotValue1["ImageUrl"] as? String {
                                                    print("NO TEXT MESSAGEE")
                                                        
                                                        let messageRead = snapshotValue1["Message Read "] as! Bool
                                                        let notified = snapshotValue1["Message Notified "] as! Bool
                                                        
                                                        
                                                        if messageRead == false {
                                                            if notified == false {
                                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: "Media received. Check Messages", badge: count, delayInterval: 3)
                                                                self.notificationPublisher.name = NAME
                                                                self.notificationPublisher.firstNametextLable = name
                                                                self.notificationPublisher.id = snapshot.key
                                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                                
                                                                count = count + 1
                                                                print("NOTIFIED IN ACTIVE \(notified)")
                                                                
                                                            }
                                                        }
                                                    }else if let videoUrl = snapshotValue1["videoUrl"] as? String {
                                                        let messageRead = snapshotValue1["Message Read "] as! Bool
                                                        let notified = snapshotValue1["Message Notified "] as! Bool
                                                        
                                                        
                                                        if messageRead == false {
                                                            if notified == false {
                                                                self.notificationPublisher.sendNotification(title: NAME, subtitle: "YOU HAVE A NEW MESSAGE", body: "Media received. Check Messages", badge: count, delayInterval: 3)
                                                                self.notificationPublisher.name = NAME
                                                                self.notificationPublisher.firstNametextLable = name
                                                                self.notificationPublisher.id = snapshot.key
                                                                ref2.child(message.key).updateChildValues(["Message Notified ": "True"])
                                                                
                                                                count = count + 1
                                                                print("NOTIFIED IN ACTIVE \(notified)")
                                                                
                                                            }
                                                        }
                                                    }
                                                    
                                            }
                                        })
                                        
                                    }
                                }
                                        
                            }

                        })
                                    
                    }
                                
                }
            }
//                    }
                }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        newMessageNotification()
        print("Resigning")

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("We are in background \(String(describing: Auth.auth().currentUser?.uid))")
      newMessageNotification()
        
        
}

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("IN FOREGROUND")
      newMessageNotification()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("ACTIVE")
    
      newMessageNotification()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("Terminated app")
       newMessageNotification()

    }
}

