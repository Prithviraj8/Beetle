//
//  NotificationPublisher.swift
//  HateDatingApp
//
//  Created by Prithviraj Murthy on 05/03/19.
//  Copyright © 2019 Prithviraj Murthy. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import Firebase

class NotificationPublisher: NSObject {
    var window: UIWindow?
    var notifyCount : Int!
    var messages = message()
    var name : String = ""
    func sendNotification(
        title: String,
        subtitle : String,
        body : String,
        badge: Int?,
        delayInterval: Int?) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        var delayTimeTrigger : UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval {
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
        }
        
        if let badge = badge {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
        }
        
        notificationContent.sound = UNNotificationSound.default()
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: "TEST NOTIFICATION", content: notificationContent, trigger: delayTimeTrigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        
        
    }
    
    
    
    
}


extension NotificationPublisher : UNUserNotificationCenterDelegate {
    
  
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("NOTIFICATION IS ABOUT TO BE PRESENTED")
        completionHandler([.badge, .sound, .alert])
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
            
        case UNNotificationDismissActionIdentifier:
                print("NOTIFICATION WAS DISMISSED")
                completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("USER OPENED THE NOTIFCATION FROM THE APP")
            window?.rootViewController = ChatLogTableViewController() 
            notifyCount = 1
            completionHandler()
            
            
        default:
            print("THE DEFAULT CASE WAS CALLED ")
            completionHandler()
        }
        
        
    }
    
}
