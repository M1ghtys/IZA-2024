//
//  HouseView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation
import SwiftUI
import SwiftData


struct HouseView: View{
    @ObservedObject var vm: HouseViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @State private var showHouseView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        if(activeUser.inHouse){
            RoomSelectionView(vm: RoomSelectionViewModel(user: activeUser.user!))
        }else{
            HouseListView()
        }
    }
}
