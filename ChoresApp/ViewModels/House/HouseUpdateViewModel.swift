//
//  HouseUpdateViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 16.05.2024.
//

import Foundation
import SwiftData


final class HouseUpdateViewModel: ObservableObject {
    @Published var name = ""
    @Published var duplicate = false
    @Published var valueError = false
    var loadedHouse : House?
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared, house: House? = nil) {
        self.dataSource = dataSource
        self.loadedHouse = house
        
        if(house != nil){
            name = loadedHouse!.name
        }
    }
    
    // adds a new house and verifies the validity and uniqueness of name input
    func addHouse(user: User) async -> Bool{
        if(name == ""){
            DispatchQueue.main.async { [weak self] in
                self?.valueError = true
            }
            return false
        }
        
        do{
            try await dataSource.addHouse(name: name, user: user)
            return true
        }catch{
            DispatchQueue.main.async { [weak self] in
                self?.duplicate = true
                self?.name = ""
            }
            return false
        }
    }
    
    // updates the house whilst checking the validity and uniqueness of the name
    func updateHouse(house: House) async -> Bool{
        if(name == ""){
            DispatchQueue.main.async { [weak self] in
                self?.valueError = true
            }
            return false
        }
        
        do{
            try await dataSource.updateHouse(house: house, name: name)
            return true
        }catch{
            DispatchQueue.main.async { [weak self] in
                self?.duplicate = true
                self?.name = ""
            }
            return false
        }
    }
}
