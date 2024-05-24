//
//  ChoreListViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 18.05.2024.
//

import Foundation
import SwiftData


final class ChoreListViewModel: ObservableObject {
    @Published var chores = [Chore]()
    var room: Room
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared, room: Room) {
        self.dataSource = dataSource
        self.room = room
    }
    
    // gets all chores for current room and sorts chores by time left untill due
    func getChoresForRoom() async {
        let roomChores = await dataSource.fetchChoresForRoom(room: room)
        let choresFiltered = roomChores.sorted(by: {
            compareTime(chore: $0) < compareTime(chore: $1)
        })
        
        DispatchQueue.main.async { [weak self] in
            self?.chores = choresFiltered
        }

    }

    // check to determine whether room can be added or removed from My Rooms
    func isUserInRoom(user: User) -> Bool{
        guard let rooms = user.rooms else{
            return false
        }
        
        let results = rooms.filter { $0 == room }
        return !results.isEmpty
    }
    
    // adds room to User, used for My Rooms filter
    func addRoomToUser(user: User) async {
        user.rooms == nil ? user.rooms = [room] : user.rooms!.append(room)
    }
    
    // removes room from user, used for My Rooms filter
    func removeUserFromRoom(user: User) async {
        if let removeIndex = user.rooms?.firstIndex(of: room){
            user.rooms?.remove(at: removeIndex)
        }
    }
    
    // deletes room and all underlying entities
    func deleteRoom()  async {
        await dataSource.deleteRoom(room: room)
    }
    
    // deletes a chore from list and removes its notification if queued
    func deleteChore(chore: Chore)  async {
        if(chore.notifID != nil){
            removeNotification(identifier: chore.notifID!)
        }
        await dataSource.deleteChore(chore: chore)
        await getChoresForRoom()
    }
}
