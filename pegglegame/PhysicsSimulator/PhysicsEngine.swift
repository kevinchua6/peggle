//
//  PhysicsEngine.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Combine

class PhysicsEngine: ObservableObject {
    func updateCoordinates(physicsBody: PhysicsBody, deltaTime seconds: CGFloat) -> PhysicsBody {
        physicsBody.update(deltaTime: seconds)
    }

    // Returns whether it has collided as well
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
//                gameObject.isHit = true
//                dynamicObject.isHit = true
            }
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

//        res = fadeOutHitPegs(gameObjList: res)

        return dynamicBody
    }
}
