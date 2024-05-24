//
//  ChoreUpdateView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 18.05.2024.
//

import Foundation
import SwiftUI

struct ChoreUpdateView: View{
    @State var modal: ActionType<User>? = nil
    @State private var showHouseView = false
    @ObservedObject var vm: ChoreUpdateViewModel
    @EnvironmentObject var activeUser : SelectedUser
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        VStack{
            
            Text("New Chore")
                .fontWeight(.semibold)
                .font(.largeTitle)
                .padding(3)
            
            
            Text("Name:")
            TextField(
                "",
                text: $vm.name
            )
            .padding()
            .border(Color.gray)
            .cornerRadius(15.0)
            
            Text("Description:")
            TextField(
                "",
                text: $vm.desc
            )
            .padding()
            .border(Color.gray)
            .cornerRadius(15.0)
            
            Toggle("Repeating: ",
                   isOn:$vm.repeating)
            DatePicker(
                "Start:",
                selection: $vm.start
            )
            
            if(vm.repeating){
                VStack{
                    HStack{
                        Text("Repeat Interval:")	
                        TextField("Interval", text: Binding(
                            get: { self.vm.interval },
                            set: { newValue in
                                self.vm.interval = newValue.filter { "0123456789".contains($0) }
                            }
                        ))
                        .keyboardType(.numberPad)
                        .padding()
                        .border(Color.gray)
                        .cornerRadius(6.0)
                        .frame(width: 80)
                    }
                    Picker("", selection: $vm.intervalType){
                        Text("Minutes").tag("Minutes")
                        Text("Hours").tag("Hours")
                        Text("Days").tag("Days")
                        Text("Weeks").tag("Weeks")
                    }
                }
                .padding()
            }else{
                DatePicker(
                    "Due:",
                    selection: $vm.end
                )
            }
           
            
            Button(
                action: {
                    Task{
                        if(await vm.addChore()){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                label: {
                    Text("Create New Chore")
                }
            )
        }
        .alert("Name already taken", isPresented: $vm.duplicity){
            Button("OK", role:.cancel){}
        }
        .alert("Incorrect value entered", isPresented: $vm.valueError){
            Button("OK", role:.cancel){}
        }
        .padding(70)
    }
    
}
