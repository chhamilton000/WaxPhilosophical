//
//  Message.swift

import Firebase

struct Message: Identifiable {
    let text: String
    let user: AppUser
    let toId: String
    let fromId: String
    let isFromCurrentUser: Bool
    let timestamp: Timestamp
    let id: String
    
    var chatPartnerId: String { return isFromCurrentUser ? toId : fromId }

    init(user: AppUser, dictionary: [String: Any]) {
        self.user = user
        
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
    }
}

