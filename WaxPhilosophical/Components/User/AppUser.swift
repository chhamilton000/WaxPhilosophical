//
//  User.swift


import Firebase
import FirebaseFirestoreSwift

struct AppUser: Identifiable, Codable {
    
    @DocumentID var uid: String?
    var username: String
    var profileImageUrl: String?
    var fullname: String
    let email: String
    var bio: String?
    var stats: UserStats?
    var isFollowed: Bool? = false
    
    var id: String { return uid ?? NSUUID().uuidString }
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
    
    var blockedUsers: [String: Bool]?
    
    var isBlocked: Bool? = false
    
}

extension AppUser: Hashable {
    var identifier: String { return id }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: AppUser, rhs: AppUser) -> Bool {
        return lhs.id == rhs.id
    }
}

