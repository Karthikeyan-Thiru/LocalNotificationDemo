//
//  HomeViewController.swift
//  LocalNotification
//
//  Created by Karthikeyan T on 07/06/2020.
//  Copyright © 2020 Karthikeyan T. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var isTimerTapped = false
    var isRepeatMode  = false
    
    @IBOutlet weak var timerView:UIView! {
        didSet {
            timerView.isHidden = true
        }
    }
    
    @IBOutlet weak var datePicker:UIDatePicker! {
        didSet {
            datePicker.minuteInterval  = 30
            datePicker.minimumDate     = Date.init()
        }
    }
    
    @IBOutlet weak var repeatModeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        //Invoking the authorizeNotification method in NotificationService class
        NotificationService.sharedInstance.authorizeNotification()
        
        //Invoking the authorizeNotification method in LocationService class
        LocationService.sharedInstance.authorizeLocation()
    }

    //MARK: - @IBAction
    @IBAction func triggerAction(_ sender: UIButton) {
        repeatModeSwitch.isOn = false
        
        if sender.tag == 0 {        // Timer Action
            isTimerTapped = true
            datePicker.datePickerMode = .countDownTimer

            self.view.bringSubviewToFront(timerView)
            timerView.isHidden = false
            
        } else if sender.tag == 1 { // Location Action
            showToast(message: "Bye Bye \(userName)")
            NotificationService.sharedInstance.requestLocationNotification()
            
        } else if sender.tag == 2 { // Date Action
            isTimerTapped = false
            datePicker.datePickerMode  = .dateAndTime
            
            self.view.bringSubviewToFront(timerView)
            timerView.isHidden = false
        }
    }
    
    @IBAction func removePendingNotifications(_ sender:UIButton) {
        let removeAllAction = UIAlertAction(title: "Remove All", style: .destructive) { (alertAction) in
            NotificationService.sharedInstance.removeAllPendingNotifications()
        }
        
        let removeTimerNotification = UIAlertAction(title: Title.timer.rawValue, style: .destructive) { (alertAction) in
            NotificationService.sharedInstance.removePendingNotifications(NotificationRequestIdentifier.timer.rawValue)
        }
        
        let removeDateNotification = UIAlertAction(title: Title.date.rawValue, style: .destructive) { (alertAction) in
            NotificationService.sharedInstance.removePendingNotifications(NotificationRequestIdentifier.date.rawValue)
        }
        
        let removeLocationNotification = UIAlertAction(title: Title.location.rawValue, style: .destructive) { (alertAction) in
            NotificationService.sharedInstance.removePendingNotifications(NotificationRequestIdentifier.location.rawValue)
        }
        
        showAlert(title: "Important", message: "Are you sure to remove the pending notifications?", actions: [removeTimerNotification, removeDateNotification, removeLocationNotification, removeAllAction])
    }
    
    @IBAction func repeatModeAction(_ sender: UISwitch) {
        isRepeatMode = sender.isOn
    }
    
    @IBAction func timerAction(_ sender:UIButton) {
        if sender.tag == 100 {
            if isTimerTapped {
                let interval = self.datePicker.countDownDuration
                NotificationService.sharedInstance.requestTimerNotification(repeatedly: self.isRepeatMode,
                                                                            withinterval: interval)
            } else {
                guard Date.init() < datePicker.date else {
                    showAlert(title: "Important", message: "Kindly select Future Date", okTitle: "Okay")
                    return
                }
                
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                                     from: datePicker.date)
                NotificationService.sharedInstance.requestDateNotification(repeatedly: isRepeatMode,
                                                                           on: dateComponents)
            }
        }
        timerView.isHidden = true
    }
}

