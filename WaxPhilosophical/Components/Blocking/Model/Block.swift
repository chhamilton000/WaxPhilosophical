//
//  BlockedUser.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 10/24/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Block: Identifiable{
    @DocumentID var id: String?
    var bockerUid: String
    var blockedUid: String
    var username: String?
}
