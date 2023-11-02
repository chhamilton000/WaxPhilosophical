//
//  ProfileViewModel.swift

import SwiftUI
import Firebase

class ProfileViewModel: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var otherUser: AppUser?
    
    @Published var userTweets = [WPQuote]()
    @Published var likedTweets = [WPQuote]()
    @Published var replies = [WPQuote]()
    @Published var injectedUserIsCurrentUser: Bool
    
    
    var userBioExists: Bool {
        let bio: String?
        if injectedUserIsCurrentUser {
            bio = currentUser?.bio
        } else {
            bio = otherUser?.bio
        }
        return !(bio?.isEmpty ?? true)
    }

    
    init(
        user: AppUser
    ) {
//        if let user = user{
            if user.id == Auth.auth().currentUser?.uid{
                injectedUserIsCurrentUser = true
                self.currentUser = user
            } else {
                otherUser = user
                injectedUserIsCurrentUser = false
            }
//        } else {
//            
//        }
        self.currentUser = user
        checkIfUserIsFollowed()
        fetchUserTweets()
        fetchLikedTweets()
        fetchUserStats()
        fetchReplies()
    }
        
    func wpQuotes() -> [WPQuote] {
        return userTweets
    }
}

// MARK: - API

extension ProfileViewModel {
    func follow() {
        guard let otherUser = otherUser else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let followingRef = FOLLOWING_COLLECTION.document(currentUid).collection("user-following")
        let followersRef = FOLLLOWER_COLLECTION.document(otherUser.id).collection("user-followers")
        
        followingRef.document(otherUser.id).setData([:]) { _ in
            followersRef.document(currentUid).setData([:]) { _ in
                self.currentUser?.isFollowed = true
                self.currentUser?.stats?.followers += 1
                
                NotificationViewModel
                    .uploadNotification(toUid: self.currentUser?.id ?? "", type: .follow)
            }
        }
    }
    
    func unfollow() {
        guard let otherUser = otherUser else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let followingRef = FOLLOWING_COLLECTION.document(currentUid).collection("user-following")
        let followersRef = FOLLLOWER_COLLECTION.document(otherUser.id).collection("user-followers")
        
        followingRef.document(otherUser.id).delete { _ in
            followersRef.document(currentUid).delete { _ in
                self.currentUser?.isFollowed = false
                self.currentUser?.stats?.followers -= 1
                
                NotificationViewModel
                    .deleteNotification(toUid: self.currentUser?.id ?? "", type: .follow)
            }
        }
    }
    
    func checkIfUserIsFollowed() {
        guard let otherUser = otherUser else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let followingRef = FOLLOWING_COLLECTION.document(currentUid).collection("user-following")
        
        followingRef.document(otherUser.id).getDocument { snapshot, _ in
            guard let isFollowed = snapshot?.exists else { return }
            self.currentUser?.isFollowed = isFollowed
        }
    }
    
    func fetchUserTweets() {
        guard let user = currentUser else { return }
        WPQOUTE_COLLECTION.whereField("uid", isEqualTo: user.id).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.userTweets = documents.map({ WPQuote(dictionary: $0.data()) })
        }
    }
    
    func fetchLikedTweets() {
        var wpQuotes = [WPQuote]()
        guard let user = currentUser else { return }
        
        USER_COLLECTION.document(user.id).collection("user-likes").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let tweetIDs = documents.map({ $0.documentID })
            
            tweetIDs.forEach { id in
                WPQOUTE_COLLECTION.document(id).getDocument { snapshot, _ in
                    guard let data = snapshot?.data() else { return }
                    let tweet = WPQuote(dictionary: data)
                    wpQuotes.append(tweet)
                    guard wpQuotes.count == tweetIDs.count else { return }
                    
                    self.likedTweets = wpQuotes
                }
            }
        }
    }
    
    func fetchReplies() {
        guard let user = currentUser else { return }
        USER_COLLECTION.document(user.id).collection("user-replies")
            .order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.replies = documents.map({ WPQuote(dictionary: $0.data()) })
            }
    }
    
    func fetchUserStats() {
        guard let user = currentUser else { return }
        UserService.fetchUserStats(user: user) { stats in
            self.currentUser?.stats = stats
        }
    }
}
