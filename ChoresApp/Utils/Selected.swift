//
//  Selected.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation


// helps with highlighting list items based on clicks
class SelectedUser: ObservableObject{
    @Published var user: User?
    @Published var houseSelected: House?
    
    var isSelected: Bool{
        return user != nil
    }
    
    var isHouseSelected: Bool{
        return houseSelected != nil
    }
    
    var inHouse: Bool{
        return user!.house != nil
    }
}
