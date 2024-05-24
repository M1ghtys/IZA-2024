//
//  ChoreListView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 18.05.2024.
//

import Foundation
import SwiftUI


// returns a text field with chore status information based on its time progression
func statusConvertor(chore: Chore)-> Text{
    
    var start: Double
    if(chore.repeating){
        let end = dateWithInterval(chore: chore)
        
        start = end.timeIntervalSince(chore.start)
    }else{
        start = chore.end!.timeIntervalSince(chore.start)
    }

    let end = Date.now.timeIntervalSince(chore.start)
    
    let timeLeft = max(0, start - end)
    let x = start > 0 ? timeLeft / start : 0
    if (x == 0){
        return Text("Overdue").foregroundStyle(.red)
    }else if (x < 0.18){
        return Text("Critical").foregroundStyle(.orange)
    }else if(x < 0.46){
        return Text("Moderate").foregroundStyle(Color(red:0.553, green:1, blue:0))
    }else{
        return Text("Normal").foregroundStyle(.green)
    }
}


struct ChoreListView: View{
    @State private var modal = false
    @StateObject var vm: ChoreListViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @Environment(\.presentationMode) var presentationMode
    @State private var deletionChore: Chore?
    @State private var deleteAlert = false
    @State private var deleteAlertRoom = false
    
    var body: some View{
        List(vm.chores){chore in
          
            NavigationLink{
                ChoreDetailView(vm: ChoreDetailViewModel(chore: chore))
            }
            label:{
                
                VStack(alignment: .leading) {
                    HStack{
                        Text(chore.name)
                            .font(.headline)
                        if(chore.repeating){
                            Spacer()
                            Text("(Interval: \(chore.interval ?? 0) \(chore.intervalType ?? "days"))")
                                .fontWeight(.ultraLight)
                        }
                    }
                    statusConvertor(chore: chore)
                        .font(.subheadline)
                    if (chore.repeating == true) {
                        Text(timeLeft(end: dateWithInterval(chore: chore)))
                        
                    } else {
                        Text(timeLeft(end:chore.end!))
                    }
                }
                
            }
            .swipeActions(edge: .leading){
                Button(action: {
                    deletionChore = chore
                    deleteAlert.toggle()
                }){
                    Image(systemName: "trash")
                }
                .tint(.red)
            }
            
        }
        .confirmationDialog(
            Text("Delete " + (deletionChore?.name ?? "") + "?" ),
            isPresented: $deleteAlert,
            titleVisibility: .visible
        ){
            Button("Delete", role: .destructive){
                Task{
                    if let chore = deletionChore{
                        await vm.deleteChore(chore: chore)
                    }
                    deletionChore = nil
                }
            }
        }
        .navigationTitle(vm.room.roomType + ": " + vm.room.name)
        .toolbar{
            Menu{
                if(vm.isUserInRoom(user: activeUser.user!)){
                    Button(action: {
                        Task{
                            await vm.removeUserFromRoom(user: activeUser.user!)
                        }
                    }){
                        Text("Remove From My Rooms")
                    }
                }else{
                    Button(action: {
                        Task{
                            await vm.addRoomToUser(user: activeUser.user!)
                        }
                    }){
                        Text("Add to My Rooms")
                    }
                }
                
                Button(role: .destructive,
                        action: {
                            deleteAlertRoom.toggle()
                        }
                    ){
                    Text("Delete Room")
                }
            }label:{
                Image(systemName: "gear")
            }
            
            Button(action: {modal.toggle()}){
                Image(systemName: "plus.circle")
            }
        }
        .confirmationDialog(
            Text("Are you sure you want to delete this room?"),
            isPresented: $deleteAlertRoom,
            titleVisibility: .visible
        ){
            Button("Delete", role: .destructive){
                Task{
                    await vm.deleteRoom()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear{
            Task{
                await vm.getChoresForRoom()
            }
        }
        .sheet(isPresented: $modal, onDismiss: {
            Task{
                await vm.getChoresForRoom()
            }
        }){
            ChoreUpdateView(vm: ChoreUpdateViewModel(room: vm.room))
        }
    }
}
