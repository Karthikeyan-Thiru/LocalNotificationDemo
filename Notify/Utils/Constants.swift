//
//  Constants.swift
//  LocalNotification
//
//  Created by Karthikeyan T on 07/06/2020.
//  Copyright © 2020 Karthikeyan T. All rights reserved.
//

import Foundation
import CoreLocation.CLCircularRegion

typealias LocationHandler = ((CLLocation) -> Void)

let userName = "Kevin"
let circularRegionRadius = 1000.0

enum NotificationAttachmentID:String {
    case timer      = "userNotification.attachment.timer"
    case date       = "userNotification.attachment.date"
    case location   = "userNotification.attachment.location"
}

enum NotificationActionID:String {
    case timer      = "userNotification.action.timer"
    case date       = "userNotification.action.date"
    case location   = "userNotification.action.location"
}

enum NotificationCategoryID:String {
    case timer      = "userNotification.category.timer"
    case date       = "userNotification.category.date"
    case location   = "userNotification.category.location"
}

enum NotificationRequestIdentifier: String {
    case timer      = "Notification.Timer"
    case date       = "Notification.Calendar"
    case location   = "Notification.Location"
}


enum Title: String {
    case timer      = "Timer"
    case date       = "Date"
    case location   = "Location"
}

enum RegionIdentifier: String {
    case home = "Home"
}

enum NotificationTitle: String {
    case timer      = "Let's drink some water and stay fit."
    case date       = "Many more happy returns of the day"
    case location   = "Welcome Back to home"
}

enum NotificationSubtitle: String {
    case timer      = "Let's drink some water and stay fit."
    case date       = "Many more happy returns of the day"
    case location   = "Welcome Back to home"
}

enum AlertTitle: String {
    case important      = "Let's drink some water and stay fit."
}
