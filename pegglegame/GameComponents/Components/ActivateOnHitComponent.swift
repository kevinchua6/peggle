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
    var imageNameHit: String

    init(imageNameHit: String) {
        isHit = false
        isActivated = false
        self.imageNameHit = imageNameHit
    }

    func activate() {
        isActivated = true
    }

    func setHit(to isHit: Bool) {
        self.isHit = isHit
    }
    
    func reset() {
        isHit = false
        isActivated = false
    }
}
