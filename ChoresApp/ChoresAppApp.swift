//
//  ChoresAppApp.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import SwiftUI
import SwiftData

@main
struct ChoresAppApp: App {
    @ObservedObject var activeUser: SelectedUser = SelectedUser()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(activeUser)
        }
    }
}

