//
//  Effects.swift
//  pegglegame
//
//  Created by kevin chua on 26/2/22.
//

import Foundation
import SwiftUI

enum Effects: String, CaseIterable {
    case normal = "Normal Mode",
         windy = "Windy Mode",
         nonsense = "Nonsense Mode"

    func getColor() -> Color {
        switch self {
        case .windy:
            return .cyan
        case .normal:
            return .black
        case .nonsense :
            return .red
        }
    }
}
