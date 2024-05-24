//
//  ChoreDetailView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 20.05.2024.
//

import Foundation
import SwiftUI

// date format for chore details
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct ChoreDetailView: View{
    @State var modal: ActionType<User>? = nil
    @State private var showHouseView = false
    @ObservedObject var vm: ChoreDetailViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @Environment(\.presentationMode) var presentationMode
    
    // function to color progress bar based on its progression
    private func colorForIndex(index: Int) -> Color {
        
        if index < vm.intervalPart {
            let colorRatio = Double(index + 1) / Double(100)
            return Color(red: colorRatio, green: 1 - colorRatio, blue: 0)
        } else {
            return Color.gray
        }
    }
    
    var body: some View{
        Form{
            Text(vm.chore.desc ?? "No description")
            
            HStack{
                VStack{
                    Text("Start")
                    Text("\(dateFormatter.string(from: vm.chore.start))")
                }
                Spacer()
                VStack{
                    if(vm.chore.repeating){
                        Text("Due every")
                        Text(String(vm.chore.interval!) + " " +	 vm.chore.intervalType!)
                    }else{
                        Text("Due")
                        Text("\(dateFormatter.string(from: vm.chore.end!))")
                    }
                }
            }
            .padding()
            VStack{
                HStack(spacing:1) {
                    Spacer() // otherwise this wont align correctly .alignment didnt work
                    ForEach(0..<100, id: \.self) { index in
                        Rectangle()
                            .fill(self.colorForIndex(index: index))
                            .frame(width: 2, height: 20)
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text(vm.status)
                }
            }
            if(vm.chore.repeating){
                
                Button(action:{// renew
                    Task{
                        await vm.refreshTask()
                    }
                }){
                    Text("Just Did This")
                }
                
            }else{
                Button(action:{// delete chore
                    Task{
                        await vm.completeTask()
                        presentationMode.wrappedValue.dismiss()
                    }
                }){
                    Text("Completed")
                }
            }
        }
        .navigationTitle(vm.chore.name)

        
    }
}
