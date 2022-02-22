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
    
    private weak var timer: Timer?

    var objArr: [GameObject]

    init(objArr: [GameObject]) {
        self.objArr = objArr
        self.physicsEngine = PhysicsEngine()
    }

    func update() -> [GameObject] {
        if let myBounds = self.bounds {
            removeObjOutsideBoundaries(bounds: myBounds)
            removeLightedUpPegsConditionally(bounds: myBounds)
        }

        simulatePhysics()

        return self.objArr
    }

    private func simulatePhysics() {
        // Update coordinates
        for gameObj in objArr {
            gameObj.physicsBody =
                self.physicsEngine.updateCoordinates(
                    physicsBody: gameObj.physicsBody,
                    deltaTime: CGFloat(1 / framesPerSecond))
        }

        // Update dynamic bodies' velocities upon collision
        for gameObj in objArr {
            // Objects stay hit
            var isHit: Bool
            (gameObj.physicsBody, isHit) =
                self.physicsEngine.updateVelocities(
                    physicsBody: gameObj.physicsBody,
                    physicsBodyArr: objArr.map { $0.physicsBody },
                    deltaTime: CGFloat(1 / framesPerSecond))
            if isHit {
                gameObj.isHit = isHit
            }
        }

        // Update the coordinates to prevent overlapping
        for gameObj in objArr {
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
        guard let ball = objArr.first(where: {
            $0.name == GameObject.Types.ball.rawValue
        }) else {
            removeLightedUpPegs()
            timer?.invalidate()
            return
        }

        let minVelocity = 20.0
        if ball.physicsBody.velocity <= minVelocity {
            if timer == nil || !(timer?.isValid ?? true) {
                timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { [self] _ in
                    self.removeLightedUpPegs()
                })
            }
        } else {
            timer?.invalidate()
        }
    }

    private func removeLightedUpPegs() {
        for gameObj in objArr where gameObj.isHit {
            if gameObj.name == GameObject.Types.bluePeg.rawValue ||
                gameObj.name == GameObject.Types.orangePeg.rawValue {
                    objArr = objArr.filter { $0 !== gameObj }
            }
        }
    }

    private func removeObjOutsideBoundaries(bounds: CGRect) {
        // Remove pegs only a certain amount away from the bounds
        let outerBounds = CGRect(
            x: bounds.minX - ADDITIONAL_WALL_LENGTH,
            y: bounds.minY - ADDITIONAL_WALL_LENGTH,
            width: bounds.width + 2 * ADDITIONAL_WALL_LENGTH,
            height: bounds.height + 2 * ADDITIONAL_WALL_LENGTH
        )

        objArr = objArr.filter {
            outerBounds.contains($0.physicsBody.boundingBox) ||
                $0.name != GameObject.Types.ball.rawValue
        }
    }
}
