//
//  RoomSelectionViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 16.05.2024.
//

import Foundation

final class RoomSelectionViewModel: ObservableObject {
    @Published var rooms = [Room]()
    @Published var filterRooms = false
    
    var user: User
    
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared, user: User) {
        self.dataSource = dataSource
        self.user = user
    }
    
    // fetches all rooms for current house
    func loadRooms(house: House) async {
        let rooms = await dataSource.fetchRoomsForHouse(house: house)
        
        DispatchQueue.main.async { [weak self] in
            if self?.filterRooms == true {
                self?.rooms = rooms.filter { $0.users?.contains(self!.user) == true }
            } else {
                self?.rooms = rooms
            }
        }
    }
    
    // leaves house, user is routed back to user selection
    func leaveHouse(user: User, house: House) async {
        await dataSource.removeUserFromHouse(user: user, house: house)
    }
    
    // deletes house and all the underlying entities
    func deleteHouse(house: House) async {
        await dataSource.deleteHouse(house: house)
    }
}
