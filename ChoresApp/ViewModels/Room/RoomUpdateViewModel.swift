//
//  RoomUpdateViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 16.05.2024.
//

import Foundation
import SwiftData


final class RoomUpdateViewModel: ObservableObject {
    @Published var name = ""
    @Published var roomType = RoomType.Other
    @Published var duplicate = false
    @Published var valueError = false
    var room : Room?
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared, room: Room? = nil) {
        self.dataSource = dataSource
        self.room = room
        
        if(room != nil){
            self.name = room!.name
            self.roomType = RoomType(rawValue: room!.roomType) ?? RoomType.Other
        }
    }
    
    // adds a new room from modal input
    func addRoom(user: User) async -> Bool{
        if(name == ""){
            DispatchQueue.main.async { [weak self] in
                self?.valueError = true
            }
            return false
        }
        
        do{
            try await dataSource.addRoom(name: name, roomType: roomType.rawValue, user: user)
            return true
        }catch{
            DispatchQueue.main.async { [weak self] in
                self?.duplicate = true
                self?.name = ""
            }
            return false
        }
    }
    
    // not used, for possible future expansion
    func updateRoom() async {
        await dataSource.updateRoom(room: room!, name: name, roomType: roomType.rawValue)
    }
    
}
