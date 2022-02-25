//
//  PhysicsComponent.swift
//  pegglegame
//
//  Created by kevin chua on 23/2/22.
//

import Foundation

class PhysicsComponent: Component {
    let physicsBody: PhysicsBody

    init(physicsBody: PhysicsBody) {
        self.physicsBody = physicsBody
    }

    func reset() {

    }
}
