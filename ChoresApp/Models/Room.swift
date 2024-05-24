//
//  Room.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftData

// string value used for display purposes
enum RoomType: String, CaseIterable, Identifiable, Codable{
    case Kitchen = "Kitchen"
    case Bathroom = "Bathroom"
    case Toilet = "Toilet"
    case DiningRoom = "Dining Room"
    case LivingRoom = "Living Room"
    case RoomT = "Room"
    case Hallway = "Hallway"
    case Attic = "Attic"
    case Basement = "Basement"
    case Other = "Other"
    
    var id: String {self.rawValue}
}

// converts roomtype to asset names
func roomToImageName(roomValue: String) -> String{
    switch roomValue{
    case "Kitchen":
        return "kitchen"
    case "Bathroom":
        return "bathroom"
    case "Toilet":
        return "toilet"
    case "Dining Room":
        return "diningroom"
    case "Living Room":
        return "livingroom"
    case "Room":
        return "room"
    case "Hallway":
        return "hallway"
    case "Attic":
        return "attic"
    case "Basement":
        return "basement"
    case "Other":
        return "other"
    default:
        fatalError("Unknown room type in class Room")
    }
}

@Model public class Room {
    var name: String
    var roomType: String
    @Relationship(deleteRule: .cascade, inverse: \Chore.room) var chores: [Chore]?
    var house: House?
    @Relationship(inverse: \User.rooms) var users: [User]?
    
    init(name: String, roomType: String, chores: [Chore]? = nil, house: House? = nil, users: [User]? = nil) {
        self.name = name
        self.roomType = roomType
        self.chores = chores
        self.house = house
        self.users = users
    }
}
