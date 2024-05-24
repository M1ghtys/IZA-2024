//
//  HouseViewModel.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation

final class HouseViewModel: ObservableObject {
    var dataSource : DataSource
    
    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
    }
}
