//
//  UpdateUserModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftData


final class UpdateUserViewModel: ObservableObject {
    @Published var name = ""
    @Published var username = ""
    @Published var duplicate = false
    @Published var valueError = false
    var loadedUser : User?
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared, user: User? = nil) {
        self.dataSource = dataSource
        self.loadedUser = user
        
        if(user != nil){
            name = loadedUser!.name
            username = loadedUser!.username
        }
    }
    
    // adds a new user based on modal values, checks for username duplicates and watches potential string.empty values
    func addUser() async -> Bool {
        if(name == "" || username == ""){
            DispatchQueue.main.async { [weak self] in
                self?.valueError = true
            }
            return false
        }
        
        do{
            let user = User(name: name, username: username, rooms: [])
            
            try await dataSource.addUser(user: user)
            return true
        }catch{
            DispatchQueue.main.async { [weak self] in
                self?.duplicate = true
                self?.username = ""
            }
            return false
        }
    }
    
    
    // updates user based on modal values, checks for username duplicates and watches potential string.empty values
    func updateUser() async -> Bool{
        if(name == "" || username == ""){
            DispatchQueue.main.async { [weak self] in
                self?.valueError = true
            }
            return false
        }
        
        do{
            try await dataSource.updateUser(user: loadedUser!, name: name, username: username)
            return true
        }catch{
            DispatchQueue.main.async { [weak self] in
                self?.duplicate = true
                self?.username = ""
            }
            return false
        }
        
    }
    
}
