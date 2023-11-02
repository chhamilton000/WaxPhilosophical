//
//  SearchView.swift

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
//    @ObservedObject var viewModel = SearchViewModel(config: .search)
    @ObservedObject var viewModel: SearchViewModel
    
    var users: [AppUser]{ searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)}

    var body: some View {
        ScrollView {
            SearchBar(text: $searchText)
                .padding()

            VStack(alignment: .leading) {
                ForEach(users) { user in
                    HStack { Spacer() }
                    
                    NavigationLink(
                        destination: OtherUserProfileView(user: user),
                        label: {
                            SearchedUserCell(user: user)
                        })
                }
            }
            .padding(.leading)
            .BottomPaddingBecauseOfCustomTabbar()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModel(config: .search))
    }
}
