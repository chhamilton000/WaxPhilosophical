//
//  ConversationsView.swift


import SwiftUI

struct MessagesView: View {
    @State var showNewMessageView = false
    @State var showChat = false
    @State var user: AppUser?
    @ObservedObject var viewModel = ConversationsViewModel()
    
    var body: some View {
        ZStack {
            
            if let user = user {
                NavigationLink(destination: ChatView(user: user),
                               isActive: $showChat,
                               label: {} )
            }
            
            if viewModel.recentMessages.isEmpty{
                Text("You have no messages at this time")
                    .foregroundColor(.primary.opacity(0.5))
                    .font(.system(size: 20, weight: .semibold))

            } else {
                ScrollView {
                    VStack {
                        ForEach(viewModel.recentMessages) { message in
                            NavigationLink(
                                destination: ChatView(user: message.user),
                                label: {
                                    ConversationCell(message: message)
                                })
                        }
                    }.padding()
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showNewMessageView.toggle()
                    }, label: {
                        Image(systemName: "envelope")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .padding()
                    })
                    .background(BlueLinearGradient())
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding()
                    .sheet(isPresented: $showNewMessageView, content: {
                        NewMessageView(show: $showNewMessageView, startChat: $showChat, user: $user)
                    })
                }
            }
        }
        .BottomPaddingBecauseOfCustomTabbar()
        .navigationTitle("Messages")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(viewModel: ConversationsViewModel())
    }
}
