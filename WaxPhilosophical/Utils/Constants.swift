//
//  Constants.swift

import SwiftUI
import Firebase

let FIRESTORE = Firestore.firestore()

let FOLLLOWER_COLLECTION = FIRESTORE.collection("followers")
let FOLLOWING_COLLECTION = FIRESTORE.collection("following")
let MESSAGE_COLLECTION = FIRESTORE.collection("messages")
let NOTIFICATION_COLLECTION = FIRESTORE.collection("notifications")
let USER_COLLECTION = FIRESTORE.collection("users")
let WPQOUTE_COLLECTION = FIRESTORE.collection("tweets")

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height


