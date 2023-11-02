//
//  UserServiceProtocol.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/25/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

protocol FirebaseUserServiceProtocol: ObservableObject where UserType: Codable{
    associatedtype UserType
    var currentUser: UserType? { get set }
    
    func fetchCurrentUser() async throws
    static func fetchUser(withUid uid: String) async throws -> UserType
    static func fetchUsers(withUidCollection uids: [String]) async throws -> [UserType]
    var userIsLoggedIn: Bool { get }
}

enum UserServiceError: Error {
    case userNotFound
}

extension FirebaseUserServiceProtocol {
    
    // Default implementation for userIsLoggedIn
    var userIsLoggedIn: Bool { return currentUser != nil }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        currentUser = try snapshot.data(as: UserType.self)
    }
    
    static func fetchUser(withUid uid: String) async throws -> UserType {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let user = try? snapshot.data(as: UserType.self) else {
            throw UserServiceError.userNotFound
        }
        return user
    }
    
    static func fetchUsers(withUidCollection uids: [String]) async throws -> [UserType] {
        var users: [UserType] = []
        
        let chunkSize = 10
        for i in stride(from: 0, to: uids.count, by: chunkSize) {
            let end = i + chunkSize
            let chunkedUids = Array(uids[i..<min(end, uids.count)])
            
            let snapshot = try await Firestore.firestore().collection("users")
                .whereField("uid", in: chunkedUids)
                .getDocuments()
            
            for document in snapshot.documents {
                if let user = try? document.data(as: UserType.self) {
                    users.append(user)
                }
            }
        }
        
        return users
    }
    
}
