//
//  HouseListViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation


final class HouseListViewModel: ObservableObject {
    @Published var houses = [House]()
    
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
    }
    
    // loads all houses sorted by name
    func loadHouses() async {
        let houses = await dataSource.fetchAllHouses()
        
        DispatchQueue.main.async { [weak self] in
            self?.houses = houses
        }
    }
    
    // adds a user to the house, making the house their new default
    func addUserToHouse(user: User, house: House) async {
        await dataSource.addUserToHouse(user: user, house: house)
    }
}
