//
//  RoomUpdateView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 16.05.2024.
//

import Foundation
import SwiftUI

struct RoomUpdateView: View{
    @ObservedObject var vm: RoomUpdateViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        
        VStack{
            if(vm.room != nil){
                Text("Edit Room")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .padding(3)
            }else{
                Text("New Room")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .padding(3)
            }
            
            Text("Name:")
            TextField(
                "",
                text: $vm.name
            )
            .padding()
            .border(Color.gray)
            .cornerRadius(15.0)
            Picker("Type of room", selection: $vm.roomType){
                ForEach(RoomType.allCases){room in
                    Text(room.rawValue).tag(room)
                }
            }
            if(vm.room != nil){
                Button(
                    action: {
                        Task{
                            await vm.updateRoom()
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    label: {
                        Text("Edit Room")
                    }
                )
            }else{
                Button(
                    action: {
                        Task{
                            if(await vm.addRoom(user: activeUser.user!)){
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    label: {
                        Text("Create New Room")
                    }
                )
            }
            
        }
        .alert("Name already taken", isPresented: $vm.duplicate){
            Button("OK", role:.cancel){}
        }
        .alert("Invalid name", isPresented: $vm.valueError){
            Button("OK", role:.cancel){}
        }
        .padding(70)
    }
}
