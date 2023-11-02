//
//  ChatViewModel.swift


import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    let user: AppUser
    @Published var messages = [Message]()
    
    init(user: AppUser) {
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let uid = UserService.shared.currentUser?.id else { return }
//        guard let userId = user.id else { return }
        let query = MESSAGE_COLLECTION.document(uid).collection(user.id)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            
            changes.forEach { change in
                let messageData = change.document.data()
                guard let fromId = messageData["fromId"] as? String else { return }
                
                USER_COLLECTION.document(fromId).getDocument { snapshot, _ in
//                    guard let data = snapshot?.data() else { return }
//                    let user = User(dictionary: data)
                    guard let user = try? snapshot?.data(as: AppUser.self) else { return }
                    self.messages.append(Message(user: user, dictionary: messageData))
                    self.messages.sort(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
                }
            }
        }
    }
    
    func sendMessage(_ messageText: String) {
//        guard let userId = user.id else { return }
        guard let currentUid = UserService.shared.currentUser?.id else { return }
        let currentUserRef = MESSAGE_COLLECTION.document(currentUid).collection(user.id).document()
        let receivingUserRef = MESSAGE_COLLECTION.document(user.id).collection(currentUid)
        let receivingRecentRef = MESSAGE_COLLECTION.document(user.id).collection("recent-messages")
        let currentRecentRef =  MESSAGE_COLLECTION.document(currentUid).collection("recent-messages")
        
        let messageID = currentUserRef.documentID
        
        let data: [String: Any] = ["text": messageText,
                                   "id": messageID,
                                   "fromId": currentUid,
                                   "toId": user.id,
                                   "timestamp": Timestamp(date: Date())]
        
        currentUserRef.setData(data)
        receivingUserRef.document(messageID).setData(data)
        receivingRecentRef.document(currentUid).setData(data)
        currentRecentRef.document(user.id).setData(data)
    }
}
