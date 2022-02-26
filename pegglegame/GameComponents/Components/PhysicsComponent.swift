//
//  PhysicsComponent.swift
//  pegglegame
//
//  Created by kevin chua on 23/2/22.
//

import CoreGraphics

class PhysicsComponent: Component {
    var physicsBody: PhysicsBody

    init(physicsBody: PhysicsBody) {
        self.physicsBody = physicsBody
    }

    func reset() {
        self.physicsBody.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody.removeForces()
    }
}
