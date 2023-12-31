//
//  NotificationViewModel.swift


import SwiftUI
import Firebase

class NotificationViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    
    init() {
        fetchNotifications()
    }
    
    static func uploadNotification(toUid uid: String, type: NotificationType, tweet: WPQuote? = nil) {
//        guard
        guard let currentUser = UserService.shared.currentUser else { return }
//        else { return }
        guard uid != currentUser.id else { return }
        
        let docRef = NOTIFICATION_COLLECTION.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": currentUser.id,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "profileImageUrl": currentUser.profileImageUrl ?? "",
                                   "username": currentUser.username]
        
        if let tweet = tweet {
            data["tweetId"] = tweet.id
        }
        
        docRef.setData(data)
    }
    
    static func deleteNotification(toUid uid: String, type: NotificationType, tweetId: String? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        NOTIFICATION_COLLECTION.document(uid).collection("user-notifications")
            .whereField("uid", isEqualTo: currentUid).getDocuments { snapshot, _ in
                snapshot?.documents.forEach({ document in
                    let notification = Notification(dictionary: document.data())
                    guard notification.type == type else { return }
                    
                    if tweetId != nil {
                        guard tweetId == notification.tweetId else { return }
                    }
                    
                    document.reference.delete()
                })
            }
    }
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = NOTIFICATION_COLLECTION.document(uid).collection("user-notifications")
            .order(by: "timestamp", descending: true)
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.notifications = documents.map({ Notification(dictionary: $0.data()) })
            
            self.fetchNotificationTweets()
            self.checkIfUserIsFollowed()
        }
    }
    
    func checkIfUserIsFollowed() {
        let followNotifications = notifications.filter({ $0.type == .follow })
        
        followNotifications.forEach { notification in
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    private func fetchNotificationTweets() {
        let tweetNotifications = self.notifications.filter({ $0.tweetId != nil })
        
        tweetNotifications.forEach { notification in
            guard let tweetID = notification.tweetId else { return }
            
            WPQOUTE_COLLECTION.document(tweetID).getDocument { snapshot, _ in
                guard let data = snapshot?.data() else { return }
                let tweet = WPQuote(dictionary: data)
                                
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.notifications[index].tweet = tweet
                }
            }
        }
    }
}
