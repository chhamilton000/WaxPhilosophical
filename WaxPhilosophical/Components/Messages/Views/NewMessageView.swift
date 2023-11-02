//
//  NewMessageView.swift

import SwiftUI

struct NewMessageView: View {
    @State var searchText = ""
    @Binding var show: Bool
    @Binding var startChat: Bool
    @Binding var user: AppUser?
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    
    var userSearchCandidates: [AppUser]{
        searchText.isEmpty ?
        viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            SearchBar(text: $searchText)
                .padding()

            VStack(alignment: .leading) {
                ForEach(userSearchCandidates) { user in
                    HStack { Spacer() }
                    
                    Button(action: {
                        self.show.toggle()
                        self.startChat.toggle()
                        self.user = user
                    }, label: {
                        SearchedUserCell(user: user)
                    })
                }
            }.padding(.leading)
        }
    }
}
