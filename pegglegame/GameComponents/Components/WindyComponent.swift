//
//  WindyComponent.swift
//  pegglegame
//
//  Created by kevin chua on 26/2/22.
//

import Foundation
import CoreGraphics

class WindyComponent: Component {
    private let WIND_STRENGTH = 500.0

    func reset() {
    }

    func applyWind(gameObj: GameObject, windDirection: CGFloat) -> PhysicsBody {
        var newPhysicsBody = gameObj.physicsBody
        newPhysicsBody.applyForce(
            force: CGVector(dx: windDirection * WIND_STRENGTH, dy: 0)
        )
        return newPhysicsBody
    }

}
