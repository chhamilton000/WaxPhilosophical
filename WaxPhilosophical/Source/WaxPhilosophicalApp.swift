//
//  WaxPhilosophicalApp.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 11/2/23.
//

import FirebaseCore
import SwiftUI

@main
struct WaxPhilosophicalApp: App {
    init() { FirebaseApp.configure() }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
