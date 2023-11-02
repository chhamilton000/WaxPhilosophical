//
//  UploadTweetViewModel.swift


import SwiftUI
import Firebase

enum WPQuoteUploadType {
    case tweet
    case reply(WPQuote)
}

class UploadWPQuoteViewModel: ObservableObject {
    @Binding var isPresented: Bool
    var tweet: WPQuote?
    let isReply: Bool
    
    init(isPresented: Binding<Bool>, wpQuote: WPQuote?) {
        self._isPresented = isPresented
        self.tweet = wpQuote
        self.isReply = wpQuote != nil
    }
    
    var profileImageUrl: URL? {
        guard let urlString = isReply ? tweet?.profileImageUrl : UserService.shared.currentUser?.profileImageUrl else { return nil }
        return URL(string: urlString)
    }
    
    var placeholderText: String {
        return isReply ? "Tweet your reply..." : "What's happening?"
    }
    
    func uploadTweet(caption: String) {
        if isReply {
            guard let tweet = tweet else { return }
            upload(caption: caption, type: .reply(tweet))
        } else {
            upload(caption: caption, type: .tweet)
        }
    }
        
    private func upload(caption: String, type: WPQuoteUploadType) {
//        guard
        guard let user = UserService.shared.currentUser else { return }
//        else { return }
        let docRef = documentReference(forUploadType: type)
        
        var data: [String: Any] = ["uid": user.id ?? "",
                                   "caption": caption,
                                   "fullname": user.fullname, "timestamp": Timestamp(date: Date()),
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl,
                                   "likes": 0,
                                   "id": docRef.documentID]
        
        switch type {
        case .reply(let tweet):
            data["replyingTo"] = tweet.username
            
            docRef.setData(data) { _ in
                let userRepliesRef = USER_COLLECTION.document(user.id ?? "").collection("user-replies").document(docRef.documentID)
                userRepliesRef.setData(data) { _ in
                    self.isPresented = false
                    NotificationViewModel.uploadNotification(toUid: tweet.uid, type: .reply, tweet: tweet)
                }
            }
        case .tweet:
            docRef.setData(data) { _ in
                self.isPresented = false 
            }
        }
    }
    
    private func documentReference(forUploadType type: WPQuoteUploadType) -> DocumentReference {
        let docRef = WPQOUTE_COLLECTION.document()
        
        switch type {
        case .reply(let tweet):
            return WPQOUTE_COLLECTION.document(tweet.id).collection("tweet-replies").document(docRef.documentID)
        case .tweet:
            return docRef
        }
    }
}
