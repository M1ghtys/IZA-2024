//
//  UpdateUserView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import SwiftUI

struct UpdateUserView: View{
    @ObservedObject var vm: UpdateUserViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View{
        
        VStack{
            if(vm.loadedUser != nil){
                Text("Edit User")
                    .fontWeight(.semibold)
                    .font(.largeTitle)
                    .padding(3)
            }else{
                Text("New User")
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
            Text("Username:")
            TextField(
                "",
                text: $vm.username
            )
            .padding()
            .border(Color.gray)
            .cornerRadius(15.0)
            
            if(vm.loadedUser != nil){
                Button(
                    action: {
                        Task{
                            if(await vm.updateUser()){
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    label: {
                        Text("Update User")
                    }
                )
            }else{
                Button(
                    action: {
                        Task{
                            if(await vm.addUser()){
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    label: {
                        Text("Create New User")
                    }
                )
            }
        }
        .alert("Username already taken", isPresented: $vm.duplicate){
            Button("OK", role:.cancel){}
        }
        .alert("Invalid name", isPresented: $vm.valueError){
            Button("OK", role:.cancel){}
        }
        .padding(70)
    }
}
