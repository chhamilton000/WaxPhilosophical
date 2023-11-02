//
//  CurrentUser_ProfileView.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/27/23.
//

import SwiftUI

struct CurrentUser_ProfileView: View {
    let user: AppUser
    @StateObject var sharedProfileViewModel: ProfileViewModel
    init(user: AppUser) {
        self.user = user
        self._sharedProfileViewModel = StateObject(wrappedValue:
                                                    ProfileViewModel(user: user))
    }
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CurrentUser_ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUser_ProfileView(user:
                                    AppUser(username: "", fullname: "", email: ""))
    }
}
