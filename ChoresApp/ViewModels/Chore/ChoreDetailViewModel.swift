//
//  ChoreDetailViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 20.05.2024.
//

import Foundation
import SwiftData
import UserNotifications

final class ChoreDetailViewModel: ObservableObject {
    @Published var chore: Chore
    var intervalPart = 0
    var dataSource : DataSource
    var status = ""
    
    init(dataSource: DataSource = DataSource.shared, chore: Chore) {
        self.dataSource = dataSource
        self.chore = chore
        if(chore.repeating){
            let now = Date.now.timeIntervalSince(chore.start)
            
            
            let end = dateWithInterval(chore: chore)
            let intervalFrom = end.timeIntervalSince(chore.start)
            let part = intervalFrom * 0.01
            
            intervalPart = Int(now/part)
            
            status = timeLeft(end: end)
            
        }else{
            let intervalFrom = chore.end!.timeIntervalSince(chore.start)
            let part = intervalFrom * 0.01
            let now = Date.now.timeIntervalSince(chore.start)
            intervalPart = Int(now/part)
            
            status = timeLeft(end: chore.end!)
            
        }
    }
    
    // renews a chore and manages a new notification for the delayed date
    func refreshTask() async {
        await dataSource.renewChore(chore: chore)
        
        if(chore.notifID != nil){
            removeNotification(identifier: chore.notifID!)
            
            var ending: Date
            if(chore.repeating){
                ending = dateWithInterval(chore: chore)
            }else{
                ending = chore.end!
            }
            
            let uuid = addNotifRequest(name: chore.name, timeTillDue: criticalDateConvert(start: chore.start, end: ending), end: ending)
            
            await dataSource.addUUIDtoChore(chore: chore, uuid: uuid)
        }
    }
    
    // completes the task by removing the notification and turning off its notification
    func completeTask() async {
        if(chore.notifID != nil){
            removeNotification(identifier: chore.notifID!)
        }
        
        await dataSource.deleteChore(chore: chore)
    }
}
