//
//  DataSource.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation
import SwiftData

final class DataSource{
    private let modelContainer: ModelContainer
    private let dbContext: ModelContext
    
    @MainActor
    static let shared = DataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: User.self, Room.self, Chore.self, House.self)
        self.dbContext = modelContainer.mainContext
    }
    
    // user
    
    func addUser(user: User){
        modelContainer.deleteAllData()
        
        return
        dbContext.insert(user)
        
        // todo try
        do{
            try dbContext.save()
        }catch{
            // todo ??
            fatalError(error.localizedDescription)
        }
    }
}
