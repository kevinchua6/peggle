//
//  PhysicsEngine.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Combine

class PhysicsEngine: ObservableObject {
    static let MAX_VELOCITY = 2_000.0

    func updateCoordinates(physicsBody: PhysicsBody, deltaTime seconds: CGFloat) -> PhysicsBody {
        physicsBody.update(deltaTime: seconds)
    }

    func updateVelocities(physicsBody: PhysicsBody,
                          physicsBodyArr: [PhysicsBody],
                          deltaTime seconds: CGFloat) -> (PhysicsBody, Bool) {
        var dynamicBody = physicsBody
        var hasCollided = false

        // To a dynamic body, all other bodies look static
        for staticBody in physicsBodyArr {
            if dynamicBody.coordinates == staticBody.coordinates {
                continue
            }

            if dynamicBody.isIntersecting(with: staticBody) {
                dynamicBody.handleCollision(with: staticBody)
                hasCollided = true
            }
        }

        let velocityMagnitude = PhysicsEngineUtils.getMagnitude(vector: dynamicBody.velocity)
        if velocityMagnitude > PhysicsEngine.MAX_VELOCITY {
            dynamicBody.velocity =
                PhysicsEngineUtils.getUnitVector(vector: dynamicBody.velocity) * PhysicsEngine.MAX_VELOCITY
        }

        return (dynamicBody, hasCollided)
    }

    func updatePreventOverlapping(
        physicsBody: PhysicsBody,
        physicsBodyArr: [PhysicsBody],
        deltaTime seconds: CGFloat) -> PhysicsBody {
        guard physicsBody.isDynamic else {
            return physicsBody
        }

        var dynamicBody = physicsBody

        dynamicBody.preventOverlapBodies()

        return dynamicBody
    }
}
