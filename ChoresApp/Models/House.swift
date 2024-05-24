//
//  House.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftData

@Model public class House {
    @Attribute(.unique) var name: String
    @Relationship(inverse: \User.house) var users: [User]?
    @Relationship(deleteRule: .cascade, inverse: \Room.house) var rooms: [Room]?
    
    init(name: String, users: [User]? = nil, rooms: [Room]? = nil) {
        self.name = name
        self.users = users
        self.rooms = rooms
    }
}
