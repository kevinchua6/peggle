//
//  SpookyBallComponent.swift
//  pegglegame
//
//  Created by kevin chua on 24/2/22.
//

import Foundation

class SpookyBallComponent: Component {
    var isSpookyBallActivated: Bool

    init() {
        isSpookyBallActivated = false
    }
    
    func activateSpookyBall() {
        isSpookyBallActivated = true
    }
    
    func deactivateSpookyBall() {
        isSpookyBallActivated = false
    }
}
