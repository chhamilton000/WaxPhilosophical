//
//  UserProfileView.swift


import FirebaseAuth
import SwiftUI
import KingfisherSwiftUI

struct CurrentUserProfileView: View {
    let user: AppUser
//    @EnvironmentObject var userService: UserService
    @StateObject var viewModel: ProfileViewModel
//    @State private var selectedFilter: TweetFilterOptions = .tweets
    @State private var editProfilePresented = false
    @State private var showBlockedList = false
    @State private var showBlockConfirmationAlert = false
    
    init(user: AppUser) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        ZStack{
            VStack{
                VStack(spacing:4){
                    KFImage(URL(string: viewModel.currentUser?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 80, height: 80)
                        .cornerRadius(40)
                    
                    Text(viewModel.currentUser?.fullname ?? "")
                        .font(.system(size: 16, weight: .semibold))

                    Text("@\(user.username)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    if let userBio = user.bio, !userBio.isEmpty{
                        Text(userBio)
                            .font(.system(size: 14))
                            .padding(.top, 8)
                    }
                    
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(user.stats?.followers ?? 0)")
                                .font(.system(size: 16)).bold()
                            
                            Text("Followers")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        
                        VStack {
                            Text("\(user.stats?.following ?? 0)")
                                .font(.system(size: 16)).bold()
                            
                            Text("Following")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        editProfilePresented.toggle()
                    }, label: {
                        Text("Edit Profile")
                            .frame(width: 360, height: 40)
                            .background(BlueLinearGradient())
                            .foregroundColor(.white)
                        
                    })
                    .cornerRadius(20)
                }
                .padding()
                
                
                Divider()
                
                ScrollView {
                    ForEach(viewModel.wpQuotes()) { wpQuote in
                        WPQuoteCell(wpQuote: wpQuote)
                            .padding()
                    }
                }
                .padding(.vertical,-8)
            }
            
//            Button("Refresh"){
//                forceRefresh.toggle()
//            }
//            .font(.system(size: 80))
            
        }
        .fullScreenCover(isPresented: $editProfilePresented) {
            EditProfileView(isShowing: $editProfilePresented, user: user)
        }

        .transition(.move(edge: .leading))
        .navigationTitle(user.fullname)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct UserProfileView_Previews: PreviewProvider{
//    static var previews: some View{
//        UserProfileView(user: User())
//    }
//}
