//
//  FirebaseAuthServiceProtocol.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/25/23.
//

import Combine
import FirebaseAuth
import Foundation


///Default implementations exist for functions:
///syncUserAndSession(),
///createUser(),
///deleteAccount(),
///handleFirbaseAuthError,
///signout(),
///login(withEmal, password)
protocol FirebaseAuthServiceProtocol: AnyObject {
    var user: User? { get set }
    var userSession: FirebaseAuth.User? { get set }
    
    var userPublisher: Published<User?>.Publisher { get }
    var userSessionPublisher: Published<FirebaseAuth.User?>.Publisher { get }
    
    func syncUserAndSession() -> AnyPublisher<(User?, FirebaseAuth.User?), Never>
}


extension FirebaseAuthServiceProtocol {
    func syncUserAndSession() -> AnyPublisher<(User?, FirebaseAuth.User?), Never> {
        return Publishers.CombineLatest(userPublisher, userSessionPublisher).eraseToAnyPublisher()
    }
}
