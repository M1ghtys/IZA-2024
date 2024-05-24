//
//  NotificationHelper.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 24.05.2024.
//

import Foundation
import UserNotifications


// performs request when a chore is added
func requestNotifications(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){sucess, error in
        if(sucess){
            print("notif. set")
        }else if let error{
            print(error.localizedDescription)
        }
    }
}


// add notification based on date values + using chore name
func addNotifRequest(name: String, timeTillDue: Double, end: Date) -> String{
    let content = UNMutableNotificationContent()
    content.title = "A chore is due"
    content.subtitle = name + " is due at " + timeToString(date: end)
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeTillDue, repeats: false)
    
    let newUUID = UUID().uuidString
    
    let request = UNNotificationRequest(identifier: newUUID, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
    
    return newUUID
}

// removes notification based on identifier saved in Chode model
func removeNotification(identifier: String){
    let identifierArr = [identifier]
    
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifierArr)
}
