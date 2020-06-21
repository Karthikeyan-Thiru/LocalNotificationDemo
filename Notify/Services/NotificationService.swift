//
//  NotificationService.swift
//  LocalNotification
//
//  Created by Karthikeyan T on 07/06/2020.
//  Copyright © 2020 Karthikeyan T. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: NSObject {
    
    //1. Singleton Class
    private override init() { }
    static let sharedInstance = NotificationService()
    
    //2. Get the current UNUserNotificationCenter
    let UNCurrentCenter = UNUserNotificationCenter.current()
    
    //3. Request the user authorization to send alerts.
    func authorizeNotification() {
        
        //3.1. Setting up the options the way you want to interact with the user.
        let options:UNAuthorizationOptions = [.alert, .badge, .sound]
        
        //3.2. Requests authorization with the user to deliver notification.
        UNCurrentCenter.requestAuthorization(options: options) { (granted, error) in
             print(error ?? "No UNAuthorization error")
            
            //3.3. completionHandler falls after the user's choice(maybe or maynot be granted).
            guard granted else {
                print("User Denied the permission to receive Push")
                return
            }
            
            //3.4. Conform to UNUserNotificationCenterDelegate
            self.UNCurrentCenter.delegate = self
        }
    }
    
    func requestTimerNotification(repeatedly:Bool = false, withinterval interval:TimeInterval) {
        
        //Specifies the payload for a local notification
        let content      = UNMutableNotificationContent()
        content.title    = "Hey \(userName)"
        content.subtitle = NotificationSubtitle.timer.rawValue
        content.sound    = UNNotificationSound.init(named: .waterSound)
        
        //Setup Time Interval Trigger to notify after the time interval, and optionally repeat
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeatedly)
        
        //Setup request to schedule a local notification
        let request = UNNotificationRequest(identifier: NotificationRequestIdentifier.timer.rawValue,
                                            content: content,
                                            trigger: trigger)
        
        //Remove the pending request if needed
        self.removePendingNotifications(NotificationRequestIdentifier.timer.rawValue)
        
        //Add the request to the current UNUserNotificationCenter
        self.UNCurrentCenter.add(request)
    }
    
    
    func requestDateNotification(repeatedly:Bool = false, on components:DateComponents) {
        
        //Specifies the payload for a local notification
        let content      = UNMutableNotificationContent()
        content.title    = "Hi \(userName), Anniverasy Wishes"
        content.subtitle = NotificationSubtitle.date.rawValue
        content.sound    = UNNotificationSound.init(named: .anniversary)

        //Setup Trigger to notify based on date and time values, and optionally repeat
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatedly)
        
        //Setup request to schedule a local notification
        let request = UNNotificationRequest(identifier: NotificationRequestIdentifier.date.rawValue,
                                            content: content,
                                            trigger: trigger)
        
        //Remove the pending request if needed
        self.removePendingNotifications(NotificationRequestIdentifier.date.rawValue)
        
        //Add the request to the current UNUserNotificationCenter
        self.UNCurrentCenter.add(request)
    }
    
    func requestLocationNotification(repeatedly:Bool = false) {
        let content      = UNMutableNotificationContent()
        content.title    = "Hi \(userName)"
        content.subtitle = NotificationSubtitle.location.rawValue
        content.sound    = UNNotificationSound.init(named: .welcomeHome)
        
        //Get the user's current Location
        LocationService.sharedInstance.updateLocation()
        
        //Getting the user's current region based on the current location
        LocationService.sharedInstance.didUpdateLocation = { [unowned self] (location) in
            
            let region           = LocationService.sharedInstance.getCurrentRegion(For: location)
            region.notifyOnEntry = true  // specified to provide notifications to be delivered on entry only
            region.notifyOnExit  = false // specified to restrict notifications to be delivered on exit.
            
            let locationTrigger  = UNLocationNotificationTrigger(region: region, repeats: repeatedly)
            let request          = UNNotificationRequest(identifier: NotificationRequestIdentifier.location.rawValue,
                                                         content: content,
                                                         trigger: locationTrigger)
            //Remove the pending request if needed
            self.removePendingNotifications(NotificationRequestIdentifier.location.rawValue)
            
            //Add the request to the current UNUserNotificationCenter
            self.UNCurrentCenter.add(request)
        }
    }
    
    func removePendingNotifications(_ requestIdentifier:String) {
        guard requestIdentifier != "" else { return }
        UNCurrentCenter.getPendingNotificationRequests(completionHandler: { [unowned self] requests in
            let pendingTimerRequests = requests.filter { return $0.identifier == requestIdentifier }.map{ $0.identifier }
            self.UNCurrentCenter.removePendingNotificationRequests(withIdentifiers: pendingTimerRequests)
        })
    }
    
    func removeAllPendingNotifications() {
        self.UNCurrentCenter.removeAllPendingNotificationRequests()
    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive response")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        
        let options:UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
