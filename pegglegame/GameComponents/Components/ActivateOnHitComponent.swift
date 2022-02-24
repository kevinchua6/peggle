//
//  ActivateOnHitComponent.swift
//  pegglegame
//
//  Created by kevin chua on 24/2/22.
//

import Foundation

class ActivateOnHitComponent: Component {
    var isHit: Bool
    var isActivated: Bool

    init() {
        isHit = false
        isActivated = false
    }

    func activate() {
        isActivated = true
    }

    func setHit(to isHit: Bool) {
        self.isHit = isHit
    }
}
