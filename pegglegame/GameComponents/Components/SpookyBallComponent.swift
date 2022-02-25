//
//  SpookyBallComponent.swift
//  pegglegame
//
//  Created by kevin chua on 25/2/22.
//

import Foundation

// Spooky ball is a property attached to the cannon ball for the effect
class SpookyBallComponent: Component {
    var shouldSpookyBallActivate: Bool

    init() {
        shouldSpookyBallActivate = false
    }

    func activateSpookyBall() {
        shouldSpookyBallActivate = true
    }

    func deactivateSpookyBall() {
        shouldSpookyBallActivate = false
    }
    
    func reset() {
        shouldSpookyBallActivate = false
    }
}


