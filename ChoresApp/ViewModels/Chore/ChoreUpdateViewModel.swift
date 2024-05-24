//
//  ChoreUpdateViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 18.05.2024.
//

import Foundation
import SwiftData
import UserNotifications

final class ChoreUpdateViewModel: ObservableObject {
    @Published var name = ""
    @Published var desc = ""
    @Published var start = Date.now
    @Published var end = Date.now
    @Published var repeating = false
    @Published var interval = "0"
    @Published var intervalType = "Hours"
    
    @Published var duplicity = false
    @Published var valueError = false
    
    
    var loadedRoom: Room
    
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared, room: Room) {
        self.dataSource = dataSource
        self.loadedRoom = room
    }
    
    // adds a new chore based on the modal input and queues a new notification to a critical point of the specified end date/interval
    func addChore() async -> Bool{
        let interval = Int(interval)
        if(name == "" || (repeating == true && (interval == nil || interval! <= 0)) || (repeating == false && addMinute(date: start) > end)){ // minute added to avoid edge cases
            DispatchQueue.main.async { [weak self] in
                self?.valueError = true
            }
            return false
        }
        
        let _desc = desc == "" ? nil : desc
        let _end = repeating ? nil : end
        let _interval = !repeating ? nil : interval


        do{
            let chore = try await dataSource.addChore(name: name, desc: _desc, start: start, end: _end, repeating: repeating, interval: _interval, intervalType: intervalType, room: loadedRoom)
            requestNotifications()
            
            
            var ending: Date
            if(repeating){
                ending = dateWithInterval(chore: chore)
            }else{
                ending = _end!
            }
            
            let uuid = addNotifRequest(name: name, timeTillDue: criticalDateConvert(start: start, end: ending), end: ending)
            
            await dataSource.addUUIDtoChore(chore: chore, uuid: uuid)
            
            return true
        }catch{
            DispatchQueue.main.async { [weak self] in
                self?.duplicity = true
            }
            return false
        }
    }
}
