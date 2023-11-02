//
//  BlueLinearGradient.swift
//  WaxPhilosophical
//
//  Created by Caley Hamilton on 9/21/23.
//

import SwiftUI

func BlueLinearGradient() -> LinearGradient {
    LinearGradient(
    stops: [
    Gradient.Stop(color: Color(red: 0.27, green: 0.8, blue: 0.91), location: 0.00),
    Gradient.Stop(color: Color(red: 0.48, green: 0.56, blue: 0.83), location: 1.00),
    ],
    startPoint: UnitPoint(x: 0, y: 0.08),
    endPoint: UnitPoint(x: 1, y: 0.82)
    )
}
