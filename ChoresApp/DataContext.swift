//
//  DataContext.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation
import SwiftData


// manages the data operations described in their corresponding callers
final class DataSource{
    private let modelContainer: ModelContainer
    private let dbContext: ModelContext
    
    @MainActor
    static let shared = DataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: User.self, House.self, Chore.self, Room.self)
        self.dbContext = modelContainer.mainContext
    }
    
    
    // USERS ----------------------------------------------------------------------
    @MainActor
    func addUser(user: User) async throws{
        var users = await fetchAllUsers()
        users = users.filter{$0.username == user.username}
        
        if(!users.isEmpty){
            throw _Error.runtimeError("username taken")
        }
        
        dbContext.insert(user)
        
        do{
            try dbContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func updateUser(user: User, name: String, username: String) async throws{
        var users = await fetchAllUsers()
        if(username != user.username){
            users = users.filter{$0.username == username}
            
            if(!users.isEmpty){
                throw _Error.runtimeError("username taken")
            }
        }
        
        user.name = name
        user.username = username
    }
    
    @MainActor
    func fetchAllUsers() async -> [User]{
        do{
            let users = try dbContext.fetch(FetchDescriptor<User>(sortBy: [SortDescriptor(\.username)]))
            return users
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchUser(fetchDescriptor: FetchDescriptor<User>) async-> [User]{
        do{
            let users = try dbContext.fetch(fetchDescriptor)
            return users
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func deleteUser(user: User) async{
        dbContext.delete(user)
    }
    // ------------------------------------------------------------------------------------
    // HOUSES -----------------------------------------------------------------------------
    @MainActor
    func addHouse(name: String, user: User) async throws{
        var houses = await fetchAllHouses()
        
        houses = houses.filter{$0.name == name}
        
        if(!houses.isEmpty){
            throw _Error.runtimeError("name taken")
        }
        
        let house = House(name: name, users: [user], rooms: [])
        dbContext.insert(house)
        
        do{
            try dbContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func updateHouse(house: House, name: String)async throws{
        var houses = await fetchAllHouses()
        houses = houses.filter{$0.name == name}
        
        if(!houses.isEmpty){
            throw _Error.runtimeError("name taken")
        }
        
        house.name = name
    }
    
    @MainActor
    func fetchAllHouses() async -> [House]{
        let descriptor = FetchDescriptor<House>(sortBy: [SortDescriptor(\.name)])
        
        do{
            let houses = try dbContext.fetch(descriptor)
            
            return houses
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func addUserToHouse(user: User, house: House) async{
        house.users!.append(user)
    }
    
    @MainActor
    func removeUserFromHouse(user: User, house: House) async{
        if let removeIndex = house.users?.firstIndex(of: user){
            house.users?.remove(at: removeIndex)
        }
    }
    
    @MainActor
    func deleteHouse(house: House) async{
        dbContext.delete(house)
        do{
            try dbContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    //------------------------------------------------------------------------------------
    // ROOMS -----------------------------------------------------------------------------
    @MainActor
    func addRoom(name: String, roomType: String, user: User) async throws{
        var rooms = await fetchRoomsForHouse(house: user.house!)
        rooms = rooms.filter{$0.name == name}
        
        if(!rooms.isEmpty){
            throw _Error.runtimeError("name taken")
        }
        
        let room = Room(name: name, roomType: roomType, chores: [], house: user.house, users: [user])
        
        
        dbContext.insert(room)
        
        do{
            try dbContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func updateRoom(room: Room, name: String, roomType: String) async{
        room.name = name
        room.roomType = roomType
    }
    
    @MainActor
    func deleteRoom(room: Room) async{
        dbContext.delete(room)
        do{
            try dbContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func fetchRoomsForHouse(house: House) async -> [Room]{
        let descriptor = FetchDescriptor<Room>()
        
        do{
            var rooms = try dbContext.fetch(descriptor)
            rooms = rooms.filter{$0.house == house}
            
            return rooms
        }catch{
            fatalError(error.localizedDescription)
        }
        
    }
    //------------------------------------------------------------------------------------
    // CHORES ----------------------------------------------------------------------------
    @MainActor
    func addChore(name: String, desc: String?, start: Date, end: Date?, repeating: Bool, interval: Int?, intervalType: String?, room: Room) async throws -> Chore{
        
        var chores = await fetchChoresForRoom(room: room)
        if(!chores.isEmpty){
            chores = chores.filter{$0.name == name}
            
            if(!chores.isEmpty){
                throw _Error.runtimeError("name taken")
            }
        }
        let chore = Chore(name: name, desc:desc, start: start, end: end, repeating: repeating,interval: interval, intervalType: intervalType, room: room)
        dbContext.insert(chore)
        
        return chore
    }
    
    @MainActor
    func addUUIDtoChore(chore: Chore, uuid: String)async{
        chore.notifID = uuid
    }
    
    @MainActor
    func deleteChore(chore: Chore) async{
        dbContext.delete(chore)
    }
    
    @MainActor
    func fetchChoresForRoom(room: Room) async->[Chore]{
        let descriptor = FetchDescriptor<Chore>()
        
        do{
            var chores = try dbContext.fetch(descriptor)
            chores = chores.filter{$0.room == room}
            
            return chores
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    @MainActor
    func renewChore(chore: Chore)async{
        chore.start = Date.now
    }
    
}
