//
//  UsersView.swift
//  ChoresApp
//
//  Created by Jakub Sychra on 14.05.2024.
//

import Foundation
import SwiftUI
import SwiftData


struct MainView: View{
    var body: some View{
        UserView()
    }
}

struct MainView_Previews: PreviewProvider {
    static let activeUser: SelectedUser = SelectedUser()

    static var previews: some View {
        MainView()
            .environmentObject(activeUser)
    }
}
