//
//  TweetActionViewModel.swift


import SwiftUI
import Firebase

class WPActionViewModel: ObservableObject {
    let wpQuote: WPQuote
    @Published var didLike = false
    
    init(wpQuote: WPQuote) {
        self.wpQuote = wpQuote
        isLiked()
    }
    
    func like() {
        guard let uid = UserService.shared.currentUser?.id else { return }
        let tweetLikesRef = WPQOUTE_COLLECTION.document(wpQuote.id).collection("tweet-likes")
        let userLikesRef = USER_COLLECTION.document(uid).collection("user-likes")
        
        WPQOUTE_COLLECTION.document(wpQuote.id).updateData(["likes": wpQuote.likes + 1]) { _ in
            tweetLikesRef.document(uid).setData([:]) { _ in
                userLikesRef.document(self.wpQuote.id).setData([:]) { _ in
                    self.didLike = true
                    NotificationViewModel.uploadNotification(toUid: self.wpQuote.uid, type: .like, tweet: self.wpQuote)
                }
            }
        }
    }
    
    func unlike() {
        guard let uid = UserService.shared.currentUser?.id else { return }
        let tweetLikesRef = WPQOUTE_COLLECTION.document(wpQuote.id).collection("tweet-likes")
        let userLikesRef = USER_COLLECTION.document(uid).collection("user-likes")
        
        WPQOUTE_COLLECTION.document(wpQuote.id).updateData(["likes": wpQuote.likes - 1]) { _ in
            tweetLikesRef.document(uid).delete { _ in
                userLikesRef.document(self.wpQuote.id).delete { _ in
                    self.didLike = false
                    
                    NotificationViewModel.deleteNotification(toUid: self.wpQuote.uid, type: .like, tweetId: self.wpQuote.id)
                }
            }
        }
    }
    
    func isLiked() {
        guard let uid = UserService.shared.currentUser?.id else { return }
        let userLikesRef = USER_COLLECTION.document(uid).collection("user-likes").document(wpQuote.id)
        
        userLikesRef.getDocument { snapshot, _ in
            guard let didLike = snapshot?.exists else { return }
            self.didLike = didLike
        }
    }
}
