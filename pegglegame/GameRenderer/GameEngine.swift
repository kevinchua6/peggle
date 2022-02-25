//
//  GameEngine.swift
//  pegglegame
//
//  Created by kevin chua on 11/2/22.
//

import Combine
import Foundation
import QuartzCore
import SwiftUI

// A game engine stores the reference to all the moving and colliding things on the screen
class GameEngine {
    private let physicsEngine: PhysicsEngine
    private var bounds: CGRect?

    private let framesPerSecond: CGFloat = 60

    private let ADDITIONAL_WALL_LENGTH = 50.0
    private let RATE_OF_FADING = 0.1

    private let MIN_VELOCITY = 150.0
    private let REMOVE_BALL_INTERVAL = 1.5

    private let HOOKS_CONSTANT = 200.0
    private let SPRING_CONSTANT = 1.0
    private let DAMPING_CONSTANT = 10.0

    private let KABOOM_MAGNITUDE = 200.0
    private let KABOOM_RADIUS = 20_000.0
    
    private weak var timer: Timer?

    var objArr: [GameObject]

    init(objArr: [GameObject]) {
        self.objArr = objArr
        self.physicsEngine = PhysicsEngine()
    }

    func update() -> [GameObject] {
        if let myBounds = self.bounds {
            // Remove pegs only a certain amount away from the bounds
            let outerBounds = CGRect(
                x: myBounds.minX - ADDITIONAL_WALL_LENGTH,
                y: myBounds.minY - ADDITIONAL_WALL_LENGTH,
                width: myBounds.width + 2 * ADDITIONAL_WALL_LENGTH,
                height: myBounds.height + 2 * ADDITIONAL_WALL_LENGTH
            )

            activateSpookyBall(bounds: outerBounds)
            removeObjOutsideBoundaries(bounds: outerBounds)
            removeLightedUpPegsConditionally(bounds: outerBounds)
        }

        simulatePhysics()

        return self.objArr
    }

    private func simulatePhysics() {
        // Update coordinates
        for gameObj in objArr.filter({ $0.physicsBody.isDynamic }) {
            gameObj.physicsBody =
                self.physicsEngine.updateCoordinates(
                    physicsBody: gameObj.physicsBody,
                    deltaTime: CGFloat(1 / framesPerSecond))
        }

        // Update dynamic bodies' velocities upon collision
        for gameObj in objArr {
            // Objects stay hit
            var isHit: Bool

            if let triangleBlock = gameObj as? TriangleBlock {
                (gameObj.physicsBody, isHit) =
                    self.physicsEngine.updateVelocities(
                        physicsBody: gameObj.physicsBody,
                        physicsBodyArr:
                            objArr.filter { $0.hasComponent(of: CannonBallComponent.self) }.map { $0.physicsBody },
                        deltaTime: CGFloat(1 / framesPerSecond))

                let magnitude: CGFloat = abs(gameObj.physicsBody.velocity * 1)

                let springRadius = triangleBlock.springRadius
                let dampAmount = springRadius / 80

                // Limit the velocity
                let maxVelocityMagnitude = 90 * dampAmount
                if magnitude >= maxVelocityMagnitude {
                    let unitVector: CGVector = gameObj.physicsBody.velocity / magnitude
                    let velocityMagnitude = min(maxVelocityMagnitude, magnitude)
                    gameObj.physicsBody.velocity = -(unitVector * velocityMagnitude)
                }

                let force: CGVector = (triangleBlock.originalCoordinates - gameObj.coordinates) * SPRING_CONSTANT
                let forceMagnitude: CGFloat = abs(force * 1)
                if forceMagnitude > 0 {
                    let forceUnitVector: CGVector = force / forceMagnitude
                    let dampedForceMagnitude = max(0, forceMagnitude * DAMPING_CONSTANT / dampAmount)
                    let resultantForce: CGVector = forceUnitVector * dampedForceMagnitude

                    gameObj.physicsBody.applyForce(
                        force: resultantForce
                    )
                }

                // Add air resistence
                let velocity: CGVector = gameObj.physicsBody.velocity
                let velocityMagnitude: CGFloat = abs(velocity * 1)

                if velocityMagnitude > 0 {
                    let velocityUnitVector: CGVector = velocity / velocityMagnitude
                    let dampedVelocityMagnitude = max(0, velocityMagnitude * 0.99)

                    let resultantVeloctity: CGVector = velocityUnitVector * dampedVelocityMagnitude
                    gameObj.physicsBody.velocity = resultantVeloctity
                }

            } else {
                (gameObj.physicsBody, isHit) =
                    self.physicsEngine.updateVelocities(
                        physicsBody: gameObj.physicsBody,
                        physicsBodyArr: objArr.map { $0.physicsBody },
                        deltaTime: CGFloat(1 / framesPerSecond)
                    )

                // Set all hittable components to hit
                if isHit {
                    gameObj.getComponent(of: ActivateOnHitComponent.self)?.setHit(to: true)
                }

                // activate spooky ball
                if gameObj.hasComponent(of: SpookyPegComponent.self) && isHit {
                    for cannonBall in objArr.filter({ !($0.getComponent(of: SpookyBallComponent.self)?.shouldSpookyBallActivate ?? false) }) {
                        cannonBall.getComponent(of: SpookyBallComponent.self)?.activateSpookyBall()
                    }
                }

                // if kaboom, boom it
                if gameObj.hasComponent(of: KaboomPegComponent.self) {
                    if let activateOnHitComponent = gameObj.getComponent(of: ActivateOnHitComponent.self) {
                        if activateOnHitComponent.isHit && !activateOnHitComponent.isActivated {
                            activateOnHitComponent.activate()

                            let kaboomPeg = gameObj
                            for obj in objArr.filter({
                                PhysicsEngineUtils.CGPointDistanceSquared(from: kaboomPeg.coordinates, to: $0.coordinates) <= KABOOM_RADIUS
                            }) {
                                if obj.hasComponent(of: CannonBallComponent.self) {
                                    // launch it away
                                    let distanceVector = obj.coordinates - kaboomPeg.coordinates
                                    let unitVector = PhysicsEngineUtils.getUnitVector(vector: distanceVector)
                                    let resultantVelocity: CGVector = obj.physicsBody.velocity + unitVector * KABOOM_MAGNITUDE
                                    
                                    var velocityMagnitude = PhysicsEngineUtils.getMagnitude(vector: resultantVelocity)
                                    
                                    // cap velocity
                                    velocityMagnitude = min(velocityMagnitude, PhysicsEngine.MAX_VELOCITY)
                                    
                                    
                                    obj.physicsBody.velocity =
                                        PhysicsEngineUtils.getUnitVector(
                                            vector: obj.physicsBody.velocity
                                        ) * velocityMagnitude

                                }

                                obj.getComponent(of: ActivateOnHitComponent.self)?.isHit = true

                            }
                        }
                    }
                }

            }
        }

        // Update the coordinates to prevent overlapping
        for gameObj in objArr.filter({
            $0.physicsBody.isDynamic
            && !$0.hasComponent(of: OscillatingComponent.self)
        }) {
            gameObj.physicsBody =
                self.physicsEngine.updatePreventOverlapping(
                    physicsBody: gameObj.physicsBody,
                    physicsBodyArr: objArr.map { $0.physicsBody },
                    deltaTime: CGFloat(1 / framesPerSecond)
                )
        }
    }

    func addObj(obj: GameObject) {
        objArr.append(obj)
    }

    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        objArr.contains(where: lambdaFunc)
    }

    func setBoundaries(bounds: CGRect) {
        self.bounds = bounds
    }

    private func removeLightedUpPegsConditionally(bounds: CGRect) {
        let ballArr = objArr.filter( {
            $0.hasComponent(of: CannonBallComponent.self)
        })

        guard ballArr.count > 0 else {
            // Remove lighted up pegs when no balls exist
            removeLightedUpPegs()
            timer?.invalidate()
            return
        }
        
        for ball in ballArr {
            if ball.physicsBody.velocity <= MIN_VELOCITY {
                if timer == nil || !(timer?.isValid ?? true) {
                    timer = Timer.scheduledTimer(withTimeInterval: REMOVE_BALL_INTERVAL, repeats: false, block: { [self] _ in
                        self.removeLightedUpPegs()
                    })
                }
            } else {
                timer?.invalidate()
            }
        }
    }

    private func removeLightedUpPegs() {
        objArr = objArr.filter {
            !($0.getComponent(of: ActivateOnHitComponent.self)?.isHit ?? false)
        }
    }

    private func removeObjOutsideBoundaries(bounds: CGRect) {
        objArr = objArr.filter {
            bounds.contains($0.physicsBody.boundingBox)
                || !$0.hasComponent(of: CannonBallComponent.self)
        }
    }

    private func activateSpookyBall(bounds: CGRect) {
        for cannonBall in objArr.filter({ $0.hasComponent(of: CannonBallComponent.self) }) {
            if (cannonBall.getComponent(of: SpookyBallComponent.self)?.shouldSpookyBallActivate ?? false)
                && !bounds.contains(cannonBall.boundingBox) {
                removeLightedUpPegs()
                cannonBall.coordinates = CGPoint(x: cannonBall.coordinates.x, y: 10)
                cannonBall.getComponent(of: SpookyBallComponent.self)?.deactivateSpookyBall()
            }
        }
        
    }
}
