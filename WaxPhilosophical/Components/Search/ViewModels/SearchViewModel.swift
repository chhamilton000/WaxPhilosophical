//
//  SearchViewModel.swift


import SwiftUI
import Firebase

enum SearchViewModelConfiguration {
    case search
    case newMessage
}

class SearchViewModel: ObservableObject {
    @Published var users = [AppUser]()
    private let config: SearchViewModelConfiguration
    
    init(config: SearchViewModelConfiguration) {
        self.config = config
        fetchUsers(forConfig: config)
    }
    
    func fetchUsers(forConfig config: SearchViewModelConfiguration) {
        USER_COLLECTION.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
//            let users = documents.map({ User(dictionary: $0.data()) })
            let users = documents.compactMap({ try? $0.data(as: AppUser.self) })
            
            switch config {
            case .newMessage:
                self.users = users.filter{ !$0.isCurrentUser }
            case .search:
                self.users = users
            }
        }
    }
    
    func filteredUsers(_ query: String) -> [AppUser] {
        let lowercasedQuery = query.lowercased()
        return users.filter{
            $0.fullname.lowercased().contains(lowercasedQuery)
            || $0.username.lowercased().contains(lowercasedQuery)
        }
    }
}
