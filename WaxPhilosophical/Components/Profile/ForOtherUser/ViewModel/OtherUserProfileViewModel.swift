//
//  OtherUserProfileViewModel.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/27/23.
//

import FirebaseAuth
import Foundation

class OtherUserProfileViewModel: ObservableObject{
    @Published var otherUser: AppUser?
}

//MARK: - Follow/Unfollow
extension OtherUserProfileViewModel{

    func follow() {
        optimistic_fontend_update(); backend_update(); confirm_successful_backend_update_with_refetch()
        func optimistic_fontend_update(){
            otherUser?.isFollowed = true
            otherUser?.stats?.followers += 1
        }
        func backend_update(){
            guard let otherUser = otherUser else { return }
            guard let currentUser = Auth.auth().currentUser else { return }
            let followingRef = FOLLOWING_COLLECTION.document(currentUser.uid).collection("user-following")
            let followersRef = FOLLLOWER_COLLECTION.document(otherUser.id).collection("user-followers")
            followingRef.document(otherUser.id).updateData([:]) { error in
                if let error = error {
                    print(error)
                    self.otherUser?.isFollowed = false
                    self.otherUser?.stats?.followers -= 1
                    return
                }
                followersRef.document(currentUser.uid).setData([:]) { _ in
                }
            }
            NotificationViewModel.uploadNotification(toUid: otherUser.id, type: .follow)
        }
    }
    
    func unfollow() {
        optimistic_fontend_update(); backend_update(); confirm_successful_backend_update_with_refetch()
        
        func optimistic_fontend_update(){
            self.otherUser?.isFollowed = false
            self.otherUser?.stats?.followers -= 1
        }
        
        func backend_update(){
            guard let otherUser = otherUser else { return }
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            let followingRef = FOLLOWING_COLLECTION.document(currentUid).collection("user-following")
            let followersRef = FOLLLOWER_COLLECTION.document(otherUser.id).collection("user-followers")
            
            followingRef.document(otherUser.id).delete { _ in
                followersRef.document(currentUid).delete { _ in
                    self.otherUser?.isFollowed = false
                    self.otherUser?.stats?.followers -= 1
                    
                    NotificationViewModel
                        .deleteNotification(toUid: self.otherUser?.id ?? "", type: .follow)
                }
            }
        }
        
    }

    private func confirm_successful_backend_update_with_refetch(){
        USER_COLLECTION.document(otherUser?.id ?? "").getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    let fetchedUser = try document.data(as: AppUser.self)
                    self.otherUser = fetchedUser
                } catch let error {
                    print("Error decoding otherUser: \(error)")
                }
            }
        }
    }
    
}
