//
//  Item.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftData

@Model public class User {
    var name: String
    @Attribute(.unique) var username: String
    var house: House?
    var rooms: [Room]?
    
    init(name: String, username: String, house: House? = nil, rooms: [Room]? = nil) {
        self.name = name
        self.username = username
        self.house = house
        self.rooms = rooms
    }
}
