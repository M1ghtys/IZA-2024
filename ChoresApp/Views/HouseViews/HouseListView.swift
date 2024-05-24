//
//  HouseListView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation
import SwiftUI

struct HouseListView: View{
    @State var modal: ActionType<User>? = nil
    @State private var showRoomView = false
    @StateObject var vm = HouseListViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var activeUser : SelectedUser
    
    var body: some View{
        NavigationStack{
            List(vm.houses){ house in
                HStack{
                    Text(house.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding()
                    .background(house == activeUser.houseSelected ? houseHighlightByMode(mode: colorScheme) : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture {
                        if(activeUser.isHouseSelected && activeUser.houseSelected == house){
                            activeUser.houseSelected = nil
                        }else{
                            activeUser.houseSelected = house
                        }
                    }
                    if(activeUser.houseSelected == house){
                        Button(action: { 
                            Task{
                                await vm.addUserToHouse(user: activeUser.user!, house: activeUser.houseSelected!)
                                showRoomView = true
                            }
                        }) {
                            Image(systemName: "house")
                                .foregroundColor(Color(red:0.859, green:0.541, blue:0.22))
                        }
                        .frame(width: 40)
                            
                    }
                }
            }
            .navigationTitle("House Selection")
            .navigationDestination(isPresented: $showRoomView){
                HouseView(vm : HouseViewModel())
            }
            .toolbar{
                if(activeUser.isHouseSelected){
                    Button(action: {modal = .updateUser},
                           label: {
                               Text("Edit")
                           }
                    )
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 1)
                        .padding(12)
                    )
                }
                Button(action: {modal = .addUser}){
                    Image(systemName: "plus.circle")
                }
            }
            .onAppear{
                Task{
                    await vm.loadHouses()
                }
            }
        }
        .sheet( item: $modal,
            onDismiss: {
                Task{
                    if(activeUser.inHouse){
                        showRoomView.toggle()
                    }else{
                        await vm.loadHouses()
                    }
                }
            },
            content: {modal in
                NavigationView {
                    switch modal{
                    case .addUser:
                        HouseUpdateView(vm: HouseUpdateViewModel())
                    case .updateUser:
                        HouseUpdateView(vm: HouseUpdateViewModel(house: activeUser.houseSelected))
                    }
                }
            }
        )
    }
}
