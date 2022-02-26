//
//  GameEffectViewModel.swift
//  pegglegame
//
//  Created by kevin chua on 26/2/22.
//

import Foundation

class GameEffectViewModel: ObservableObject {
    @Published var effect: Effects = Effects.normal
}
