//
//  OscillatingComponent.swift
//  pegglegame
//
//  Created by kevin chua on 24/2/22.
//

import CoreGraphics

class OscillatingComponent: Component {
    private let HOOKS_CONSTANT = 200.0
    private let SPRING_CONSTANT = 1.0
    private let DAMPING_CONSTANT = 10.0
    private let INITIAL_SPEED_RATIO: CGFloat = 90 / 80
    private let DAMP_RATIO: CGFloat = 80

    let originalCoordinates: CGPoint
    var springRadius: CGFloat

    init(originalCoordinates: CGPoint, springRadius: CGFloat) {
        self.originalCoordinates = originalCoordinates
        self.springRadius = springRadius
    }

    func reset() {
    }

    func updateVelocityOnHit(gameObj: GameObject, objArr: [GameObject], physicsEngine: PhysicsEngine) {

        (gameObj.physicsBody, _) =
            physicsEngine.updateVelocities(
                physicsBody: gameObj.physicsBody,
                physicsBodyArr:
                    objArr.filter { $0.hasComponent(of: CannonBallComponent.self) }.map { $0.physicsBody },
                deltaTime: CGFloat(1 / 60.0))

        let magnitude: CGFloat = PhysicsEngineUtils.getMagnitude(vector: gameObj.physicsBody.velocity)

        let dampAmount = springRadius / DAMP_RATIO

        // Limit the velocity
        let maxVelocityMagnitude = springRadius * INITIAL_SPEED_RATIO
        if magnitude >= maxVelocityMagnitude {
            let unitVector: CGVector = gameObj.physicsBody.velocity / magnitude
            let velocityMagnitude = min(maxVelocityMagnitude, magnitude)
            gameObj.physicsBody.velocity = -(unitVector * velocityMagnitude)
        }

        // force to move back to original position
        let force: CGVector = (originalCoordinates - gameObj.coordinates) * SPRING_CONSTANT
        let forceMagnitude = PhysicsEngineUtils.getMagnitude(vector: force)
        if forceMagnitude > 0 {
            let forceUnitVector: CGVector = force / forceMagnitude
            let dampedForceMagnitude = max(0, forceMagnitude * DAMPING_CONSTANT / dampAmount)
            let resultantForce: CGVector = forceUnitVector * dampedForceMagnitude

            gameObj.physicsBody.applyForce(
                force: resultantForce
            )
        }

        // Add damping
        let velocity: CGVector = gameObj.physicsBody.velocity
        let velocityMagnitude: CGFloat = abs(velocity * 1)

        if velocityMagnitude > 0 {
            let velocityUnitVector: CGVector = velocity / velocityMagnitude
            let dampedVelocityMagnitude = max(0, velocityMagnitude * 0.99)

            let resultantVeloctity: CGVector = velocityUnitVector * dampedVelocityMagnitude
            gameObj.physicsBody.velocity = resultantVeloctity
        }
    }
}
