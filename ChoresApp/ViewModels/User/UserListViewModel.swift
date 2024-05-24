//
//  UserListViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation

final class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var duplicate = false
    
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
    }
    
    // loads all users, users are sorted by username
    func loadUsers() async {
        let users = await dataSource.fetchAllUsers()
        
        DispatchQueue.main.async { [weak self] in
            self?.users = users
        }
    }
    
    // deletes user 
    func deleteUser(user: User) async {
        await dataSource.deleteUser(user: user)
        await loadUsers()
    }
}
