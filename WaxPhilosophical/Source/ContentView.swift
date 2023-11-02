//
//  ContentView.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 11/2/23.
//

import KingfisherSwiftUI
import SwiftUI

struct ContentView: View {
    
    @StateObject var authService = AuthService.shared
    @StateObject var userService = UserService.shared
    
    var body: some View {
        Group {
            ZStack{
                if userService.authState == .loggedIn {
                    if let user = userService.currentUser{
                        TabsView(user: user)
                            .environmentObject(userService)
                    }
                } else if userService.authState == .undetermined {
                    ProgressView()
                } else {
                    LoginView()
                        .environmentObject(authService)
                }
            }
        }
        .environmentObject(userService)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @State var user: AppUser = .init(username: "", fullname: "", email: "")
        ContentView()
            .environmentObject(TabbarService.shared)
    }
}

