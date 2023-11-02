//
//  ConversationsViewModel.swift


import SwiftUI

class ConversationsViewModel: ObservableObject {
    @Published var recentMessages = [Message]()
    private var recentMessagesDictionary = [String: Message]()
    @EnvironmentObject var userService: UserService
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let uid = UserService.shared.currentUser?.id else { return }
        
        let query = MESSAGE_COLLECTION.document(uid).collection("recent-messages")
        query.order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges else { return }
            
            changes.forEach { change in
                let messageData = change.document.data()
                let uid = change.document.documentID
                
                USER_COLLECTION.document(uid).getDocument { snapshot, _ in
                    guard let user = try? snapshot?.data(as: AppUser.self) else { return }
                    
                    self.recentMessagesDictionary[uid] = Message(user: user, dictionary: messageData)
                    self.recentMessages = Array(self.recentMessagesDictionary.values)
                }
            }
        }
    }
}
