//
//  MenuView.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/26/23.
//

import KingfisherSwiftUI
import SwiftUI

struct MenuView: View {
    @Binding var user: AppUser
    @Binding var showMenu: Bool
    @EnvironmentObject var userService: UserService
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 15) {
                
                HStack{
                    KFImage(URL(string: user.profileImageUrl ?? ""))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Button(action:{
                        showMenu.toggle()
                    },label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    })
                    .padding(.trailing)
                }
                
                Text(user.fullname)
                    .font(.title2.bold())
                
                Text("@\(user.username)")
                    .font(.callout)
                
                if let numFollowers = user.stats?.followers,
                   let numFollowing = user.stats?.following{
                    //                    Divider()
                    HStack(spacing: 12){
                        
                        Label {
                            Text("Followers")
                        } icon: {
                            Text("\(numFollowers)")
                                .fontWeight(.bold)
                        }
                        
                        Label {
                            Text("Followers")
                        } icon: {
                            Text("\(numFollowing)")
                                .fontWeight(.bold)
                        }
                        
                    }
                    .foregroundColor(.primary)
                }
            }
                    .padding()
                    .padding(.leading)
                
                Divider()
                
//                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 10){
                        
                        VStack(alignment: .leading, spacing: 45) {
                            
                            NavigationLink(destination: {
                                CurrentUserProfileView(user: user)
                            }, label: {
                                HStack{
                                    Image(systemName: "person.crop.circle")
                                    Text("Profile")
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .foregroundColor(.primary)
                            })
                            
                            NavigationLink(destination: {
                                Text("Blocked Users")
                            }, label: {
                                HStack{
                                    Image(systemName: "person.fill.xmark.rtl")
                                    Text("Blocked users")
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .foregroundColor(.primary)
                            })

                            NavigationLink(destination: {
                                TermsOfServiceView()
                            }, label: {
                                HStack{
                                    Image(systemName: "newspaper")
                                    Text("Terms of service")
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .foregroundColor(.primary)
                            })
                            
                            Button(action: {
                                Task{ try await AuthService.shared.signOut() }
                            }, label: {
                                HStack{
                                    Image(systemName: "arrow.left.square")
                                    Text("Log out")
                                        .font(.subheadline)
                                    Spacer()
                                }
                                .foregroundColor(.primary)
                            })
                        }
                        .padding(.horizontal)
                        .padding(.leading)
                        .padding(.top,35)
                        
                        Divider()
                            .padding(.vertical)
                        
                        Button(action: {
                            
                        }, label: {
                            HStack{
                                Image(systemName: "exclamationmark.triangle")
                                Text("Delete Account")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .foregroundColor(.red)

                        })
                        .padding(.horizontal)
                        .padding(.leading)

                        
                        Divider()
                            .padding(.vertical)
                        
                        Spacer()
                            
                        VStack(alignment: .leading, spacing: 12){
                            HStack{
                                ZStack{
                                    Circle()
                                        .frame(width: 40, height: 40)
                                        .foregroundLinearGradient(with: BlueLinearGradient())
                                    Image("philosophyIcon")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 32)
                                }
                            }
                            
                            HStack{
                                Text("Wax Philosophical")
                                    .font(.title2.bold())
                                
                                Spacer()
                            }
                            
                            Text("Version 1.0.0")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                        .padding()
                        .padding(.leading)
                        

                            
                    }
//                }
                
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .frame(width: SCREEN_WIDTH - 90)
            .frame(maxHeight: .infinity)
            .background(
                
                Color.primary
                    .opacity(0.04)
                    .ignoresSafeArea(.container, edges: .vertical)
            )
        }
    
    @ViewBuilder
    func MenuSelection(title: String,image: String)->some View{
        
        // For navigation...
        // Simple replace button with Navigation Links...
        
        NavigationLink {
            
            Text("\(title) View")
                .navigationTitle(title)
            
        } label: {
            
            HStack(spacing: 14){
                
                Image(image)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 22, height: 22)
                
                Text(title)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity,alignment: .leading)
        }
    }
}
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
    
    func safeArea()->UIEdgeInsets{
        let null = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return null
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return null
        }
        
        return safeArea
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(user: .constant(AppUser(username: "", fullname: "", email: "")),
                 showMenu: .constant(true))
            .environmentObject(UserService.shared)
    }
}
