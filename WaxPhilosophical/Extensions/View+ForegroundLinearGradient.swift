//
//  ForegroundLinearGradient.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 9/21/23.
//

import SwiftUI

extension View { // Gradient for navigation bar
    public func foregroundLinearGradient(with linearGradient: LinearGradient) -> some View {
        self.overlay( linearGradient.mask(self) )
    }
}

