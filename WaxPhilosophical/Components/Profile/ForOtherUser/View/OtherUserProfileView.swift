//
//  ProfileViewForOtherUser.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/27/23.
//

import Firebase
import SwiftUI
import KingfisherSwiftUI

struct OtherUserProfileView: View {
    var user: AppUser
    @ObservedObject private var viewModel: ProfileViewModel
//    @State private var selectedFilter: TweetFilterOptions = .tweets
    @State private var editProfilePresented = false
    @State private var showBlockedList = false
    @State private var showBlockConfirmationAlert = false
    
    init(user: AppUser?) {
            self.viewModel = ProfileViewModel(user: user!)
            self.user = user!
    }
    
    var isCurrentUser: Bool{ Auth.auth().currentUser?.uid ?? "" == user.id }
    
    var body: some View {
        VStack{
            VStack(spacing:4){

                KFImage(URL(string: user.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 80, height: 80)
                    .cornerRadius(80 * 0.5)
                
                Text(user.fullname)
                    .font(.system(size: 16, weight: .semibold))
    //                .padding(.top, 8)
                
                Text("@\(viewModel.currentUser?.username ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let userBio = user.bio, !userBio.isEmpty{
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
            .padding()
            
            Divider()
            
            ScrollView {
                ForEach(viewModel.wpQuotes()){ wpQuote in
                    WPQuoteCell(wpQuote: wpQuote)
                        .padding()
                }
            }
            .padding(.vertical,-8)
        }
        .transition(.move(edge: .leading))
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        
                    }, label: {
                        VStack{
                            Image(systemName: "person.fill.xmark.rtl")
                                .font(.system(size: 10))
                            Text("block")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    })
            }
        }
    }}

