//
//  AuthViewModel.swift
//  
//
//  Created by Caley Hamilton on 10/15/23
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

enum LoginError: Int {
    case accountDisabled = 17005
    case invalidEmail = 17008
    case incorrectPassword = 17009
    case tooManyFailedAttempts = 17010
    case noUserWithThisEmail = 17011
    case networkConnectionIssue = 17020
}

enum SignupError: Int{
    case emailAlreadyInUse = 17007
    case invalidEmail = 17008
    case networkConnectionIssue = 17020
}

enum AuthState{ case undetermined, loggedIn, loggedOut}

class AuthService: ObservableObject {
    @Published var errorMessage: String?
    
    @Published var loggedInUser: AppUser?
    
    @Published var state: AuthState = .undetermined
    
    private init(){
        DispatchQueue.main.async {
            Task{ self.loadCurrentUserData() }
        }
    }
    
    static let shared = AuthService()
    
    func reloadCurrentUsersData() {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            USER_COLLECTION.document(userId).getDocument { snapshot, error in
                guard let snapshot = snapshot else { return }
                do { self.loggedInUser = try snapshot.data(as: AppUser.self)}
                catch{ print(error) }
            }
    }

    func loadCurrentUserData(){
        if let currentUser = Auth.auth().currentUser{
            USER_COLLECTION.document(currentUser.uid).getDocument { [weak self] snapshot, error in
                guard let snapshot = snapshot else { return }
                
                do {
                    self?.loggedInUser = try snapshot.data(as: AppUser.self)
                    self?.state = .loggedIn
                } catch {
                    self?.state = .loggedOut
                }
            }
        }
        else {
            state = .loggedOut
        }
    }
    
    
    private func handleFirebaseAuthError(_ error: NSError) {
        switch error.code {
        case SignupError.emailAlreadyInUse.rawValue:
            self.errorMessage = "This email is already in use"
        case SignupError.invalidEmail.rawValue:
            self.errorMessage = "Invalid email."
        case SignupError.networkConnectionIssue.rawValue:
            self.errorMessage = "Please check your network connection and try again."
        default:
            self.errorMessage = error.localizedDescription
        }
     }

    
//    var userIsLoggedIn: Bool{ UserService.shared.userSession != nil }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            loggedInUser = try await UserService.shared
                .fetchUser(withUid: result.user.uid)
            state = .loggedIn
//            UserService.shared.userSession = result.user
            self.errorMessage = nil  // Clear any previous error message
        } catch let error as NSError{
            handleFirebaseAuthError(error)
            print(error)
            throw error
        }
    }
    
    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        do {
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let data: [String: Any] = [
                "email": email,
                "username": username,
                "id": result.user.uid
            ]
            
            try await USER_COLLECTION.document(result.user.uid).setData(data)
            loggedInUser = try await UserService.shared.fetchUser(withUid: result.user.uid)
            state = .loggedIn
            
//            UserService.shared.userSession = result.user
            
        } catch {
            
            if let error = error as NSError? {
                 handleFirebaseAuthError(error)
                 throw error
             } else {
                 self.errorMessage = error.localizedDescription
             }
            
        }
    }

    @MainActor
    func signOut() async throws {
        do {
            state = .loggedOut
            loggedInUser = nil
            try Auth.auth().signOut()
        } catch let error as NSError {
            handleFirebaseAuthError(error)
        }
    }
    
}


