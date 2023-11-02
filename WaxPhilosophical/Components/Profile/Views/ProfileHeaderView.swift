//
//  ProfileHeaderView.swift

import SwiftUI
import KingfisherSwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var editProfilePresented: Bool
    @EnvironmentObject var userService: UserService
    @Binding var user: AppUser
    
    
    var body: some View {
        VStack(spacing:4){
            KFImage(URL(string: userService.currentUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: 80, height: 80)
                .cornerRadius(40)
            
            Text(viewModel.currentUser?.fullname ?? "")
                .font(.system(size: 16, weight: .semibold))
            
            Text("@\(viewModel.currentUser?.username ?? "")")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if let userBio = viewModel.currentUser?.bio, !userBio.isEmpty{
                Text(userBio)
                    .font(.system(size: 14))
                    .padding(.top, 8)
            }
            
            HStack(spacing: 40) {
                VStack {
                    Text("\(viewModel.currentUser?.stats?.followers ?? 0)")
                        .font(.system(size: 16)).bold()
                    
                    Text("Followers")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    Text("\(viewModel.currentUser?.stats?.following ?? 0)")
                        .font(.system(size: 16)).bold()
                    
                    Text("Following")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            ProfileActionButtonView(user: $user, viewModel: viewModel, editProfilePresented: $editProfilePresented)
        }
    }
}
