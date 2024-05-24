//
//  RoomSelectionView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 16.05.2024.
//

import Foundation
import SwiftUI

struct RoomSelectionView: View{
    @State var modal: ActionType<User>? = nil
    @State private var myRooms = false
    @StateObject var vm: RoomSelectionViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var deleteAlert = false
    
    var body: some View{
        NavigationStack{
            Toggle("My Rooms", isOn: $vm.filterRooms)
                .padding()
                .onChange(of: vm.filterRooms){
                    Task{
                        await vm.loadRooms(house: activeUser.user!.house!)
                    }
                }
            ScrollView{
            
                LazyVGrid(columns: [.init(.adaptive(minimum: 150, maximum: .infinity), spacing: 5)], spacing: 5) {
                    ForEach(vm.rooms) { room in
                        NavigationLink{
                            ChoreListView(vm: ChoreListViewModel(room: room))
                        }label: {
                            VStack{
                                Image(roomToImageName(roomValue: room.roomType))
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .aspectRatio(1, contentMode: .fit)
                                Text(room.name)
                            }
                        }
                    }
                }
                .navigationTitle("Room Selection")
                .toolbar{
                    
                Menu{
                    Button(action: {
                        Task{
                            await vm.leaveHouse(user: activeUser.user!, house: activeUser.user!.house!)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }){
                        Text("Leave House")
                    }
                    Button(role: .destructive,
                            action: {
                                deleteAlert.toggle()
                            }
                        ){
                        Text("Delete House")
                    }
                }label:{
                    Image(systemName: "gear")
                }
                
                Button(action: {modal = .addUser}){
                    Image(systemName: "plus.circle")
                }
                }
                .onAppear{
                    Task{
                        await vm.loadRooms(house: activeUser.user!.house!)
                    }
                }
            }
        }
        .confirmationDialog(
            Text("Are you sure you want to delete this house?"),
            isPresented: $deleteAlert,
            titleVisibility: .visible
        ){
            Button("Delete", role: .destructive){
                Task{
                    await vm.deleteHouse(house: activeUser.user!.house!)
                    activeUser.user?.house = nil
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        /*.onChange(of: colorScheme){old, new in  // tested fix for ui refresh on theme change -> triggers but doesnt help with the bug and rooms stay empty even tho they are filled correctly
            vm.loadRooms(house: activeUser.user!.house!)
        }*/
        .sheet( item: $modal,
            onDismiss: {
            Task{
                await vm.loadRooms(house: activeUser.user!.house!)
            }
            },
            content: {modal in
                NavigationView {
                    if(modal == .addUser){
                        RoomUpdateView(vm: RoomUpdateViewModel())
                    }
                }
            }
        )
    }
}
