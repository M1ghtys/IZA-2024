//
//  HouseUpdateView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 15.05.2024.
//

import Foundation
import SwiftUI
import SwiftData


struct HouseUpdateView: View{
    @ObservedObject var vm: HouseUpdateViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        
        VStack{
            if(vm.loadedHouse != nil){
                Text("Edit House")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .padding(3)
            }else{
                Text("New House")
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
            
            if(vm.loadedHouse != nil){
                Button(
                    action: {
                        Task{
                            if(await vm.updateHouse(house: vm.loadedHouse!)){
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    label: {
                        Text("Edit House")
                    }
                )
            }else{
                Button(
                    action: {
                        Task{
                            if(await vm.addHouse(user: activeUser.user!)){
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    label: {
                        Text("Create New House")
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
