//
//  Chore.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftData

enum StatusType: String, CaseIterable, Identifiable, Codable{
    case Normal = "Normal"
    case Moderate = "Moderate"
    case Severe = "Severe"
    case Critical = "Critical"
    
    var id: String {self.rawValue}
}

@Model public class Chore {
    var name: String
    var desc: String?
    var start: Date // acts as "last done date" if repeating is true
    var end: Date?
    var repeating: Bool
    var interval: Int? = 0
    var intervalType: String? = ""
    var notifID: String?
    var room: Room?
    
    init(name: String, desc: String? = nil, start: Date, end: Date? = nil, repeating: Bool, interval: Int? = nil, intervalType: String? = nil, room: Room) {
        self.name = name
        self.desc = desc
        self.start = start
        self.end = end
        self.repeating = repeating
        self.interval = interval
        self.intervalType = intervalType
        self.room = room
    }
}
