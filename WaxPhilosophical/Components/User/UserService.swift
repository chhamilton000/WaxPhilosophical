//
//  UserService.swift


import Firebase
import FirebaseAuth

class UserService: ObservableObject{
    
    @Published private var auth = AuthService.shared
    
    static let shared = UserService()
    
    var currentUser: AppUser?{ auth.loggedInUser }
    
    var userIsLoggedIn: Bool{ auth.loggedInUser != nil }
    
    var authState: AuthState{ auth.state }
    
    private init(){ }
    
    typealias UserType = AppUser
    
}

//MARK: - Profile pic uploading
extension UserService{
    func uploadProfilePic(profilePicData: Data) async {
//        guard let currentUserId = currentUser?.id else { return }
        guard let currentUser = currentUser else { return }

        do {
            // Upload the new profile image and get the download URL
            let newProfilePicUrl = try await UploadImageService
                .shared.uploadAndCleanUpProfileImage(
                newProfileImage: profilePicData,
                for: currentUser.id
            )

            // Update Firestore with the new profile image URL
            let userDocument = Firestore.firestore().collection("users").document(currentUser.id)
            try await userDocument.updateData([
                "profileImageUrl": newProfilePicUrl
            ])

            DispatchQueue.main.async {
                Task{ self.auth.reloadCurrentUsersData }
            }

        } catch {
            print("Error uploading new profile pic: \(error)")
        }
    }
}

//MARK: - Following/Followers functionality
extension UserService {
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        FOLLOWING_COLLECTION.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }

    static func fetchUserStats(user: AppUser, completion: @escaping(UserStats) -> Void) {
        let followersRef = FOLLLOWER_COLLECTION.document(user.id).collection("user-followers")
        let followingRef = FOLLOWING_COLLECTION.document(user.id).collection("user-following")

        followersRef.getDocuments { snapshot, _ in
            guard let followerCount = snapshot?.documents.count else { return }

            followingRef.getDocuments { snapshot, _ in
                guard let followingCount = snapshot?.documents.count else { return }

                completion(UserStats(followers: followerCount, following: followingCount))
            }
        }
    }
}

//MARK: - Fetching User
extension UserService{
    
    @MainActor
    func fetchUser(withUid uid: String) async throws -> AppUser{
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: AppUser.self)
    }
    
}

//MARK: - Updating fullname and
extension UserService{
    func update(fullname: String) {
        optimistic_fontend_update(); backend_update(); confirm_successful_backend_update_with_refetch()
        
        
        
        func optimistic_fontend_update(){
            DispatchQueue.main.async {
//                UserService.shared.currentUser?.fullname =
                self.auth.loggedInUser?.fullname = fullname
            }
        }
        func backend_update(){
            guard let uid = currentUser?.uid else { return }
            USER_COLLECTION.document(uid).updateData(["fullname":fullname])
        }
        func confirm_successful_backend_update_with_refetch(){
            auth.reloadCurrentUsersData()
        }
    }
}
//
//        guard let currentUser = currentUser else { return }
//
//        let currentUsersId = currentUser.id
//        do{
//            try await USER_COLLECTION.document(currentUsersId).updateData(["fullname":fullname])
//
//            DispatchQueue.main.async {
//                Task{ self.auth.reloadCurrentUsersData }
//            }
//
//        } catch {
//            print(error)
//        }
