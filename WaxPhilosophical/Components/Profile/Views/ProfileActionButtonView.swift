//
//  ProfileActionButtonView.swift


import SwiftUI

struct ProfileActionButtonView: View {
    @Binding var user: AppUser
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var editProfilePresented: Bool
    
    var body: some View {
        if viewModel.injectedUserIsCurrentUser{
            Button(action: {
                editProfilePresented.toggle()
            }, label: {
                Text("Edit Profile")
                    .frame(width: 360, height: 40)
                    .background(BlueLinearGradient())
                    .foregroundColor(.white)
                
            })
            .fullScreenCover(isPresented: $editProfilePresented) {
                EditProfileView(isShowing: $editProfilePresented, user: user)
            }
            .cornerRadius(20)
//                                ,
//                                profileImageUrl: $viewModel.user?.profileImageUrl)
//            }
        } else {
            HStack {
                Button(action: {
                    viewModel.otherUser?.isFollowed ?? false ? viewModel.unfollow() : viewModel.follow()
                }, label: {
                    Text(viewModel.otherUser?.isFollowed ?? false ? "Following" : "Follow")
                        .frame(width: 180, height: 40)
                        .background(BlueLinearGradient())
                        .foregroundColor(.white)
                    
                })
                .cornerRadius(20)
                
                if let otherUser = viewModel.otherUser{
                    NavigationLink(destination: ChatView(user: otherUser), label: {
                        Text("Message")
                            .frame(width: 180, height: 40)
                            .background(Color.purple)
                            .foregroundColor(.white)
                    })
                    .cornerRadius(20)
                }
            }
        }
    }
}
