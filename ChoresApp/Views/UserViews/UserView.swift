//
//  UserView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftUI
import SwiftData

// modal enum update/add, used in multiple views
enum ActionType<T>: Identifiable{
    var id: String{
        switch self {
        case .addUser: return "addUser"
        case .updateUser: return "updateUser"
        }
    }
    
    case addUser
    case updateUser
}

struct UserView: View{
    @State var modal: ActionType<User>? = nil
    @State private var showHouseView = false
    @State private var deleteAlert = false
    @StateObject var vm = UserListViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var activeUser : SelectedUser
    @State private var deletionUser: User? // fix for invalid user being passed due to state within closure
    
    var body: some View{
        
        NavigationStack{
            List(vm.users){ user in
                HStack{
                    VStack(alignment: .leading){
                        Text(user.name)
                        Text("("+user.username+")")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding()
                    .background(
                        user == activeUser.user ? userHighlightByMode(mode: colorScheme) : Color.clear
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        if(activeUser.isSelected && activeUser.user == user){
                            activeUser.user = nil
                        }else{
                            activeUser.user = user
                        }
                    }
                    if(activeUser.user == user){
                        Button(action: {
                            showHouseView = true
                        }) {
                            Image(systemName: "house")
                                .foregroundColor(.blue)
                        }
                        .frame(width: 40)
                        	
                    }
                }
                .swipeActions(edge: .leading){
                    Button(action: {
                        deletionUser = user
                        deleteAlert.toggle()
                    }){
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
                
                
            }
            .confirmationDialog(
                Text(deletionUser?.username ?? "" ),
                isPresented: $deleteAlert,
                titleVisibility: .visible
            ){
                Button("Delete", role: .destructive){
                    Task{
                        if let user = deletionUser{
                            if(user == activeUser.user){
                                activeUser.user = nil
                            }
                            await vm.deleteUser(user: user)
                        }
                        deletionUser = nil
                    }
                }
            }
            .navigationTitle("User Selection")
            .navigationDestination(isPresented: $showHouseView){
                HouseView(vm : HouseViewModel())
            }
            .toolbar{
                if(activeUser.isSelected){
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
                    await vm.loadUsers()
                }
            }
        }
        	
        .sheet( item: $modal,
                onDismiss: {
                Task{
                    await vm.loadUsers()
                }
            },
            content: {modal in
                NavigationView {
                    switch modal{
                    case .addUser:
                        UpdateUserView(vm: UpdateUserViewModel())
                    case .updateUser:
                        UpdateUserView(vm: UpdateUserViewModel(user: activeUser.user))
                    }
                }
            }
        )
    }
}
