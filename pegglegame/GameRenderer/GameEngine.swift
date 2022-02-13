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

    private let ADDITIONAL_WALL_LENGTH = 200.0
    private let RATE_OF_FADING = 0.1

    var gameObjList: [GameObject]

    init(gameObjList: [GameObject]) {
        self.gameObjList = gameObjList
        self.physicsEngine = PhysicsEngine()
    }

    func update() -> [GameObject] {
        if let myBounds = self.bounds {
            removeObjOutsideBoundaries(bounds: myBounds)
            removeLightedUpPegsConditionally(bounds: myBounds)
        }

        simulatePhysics()

        return self.gameObjList
    }

    private func simulatePhysics() {
        // Update coordinates
        for gameObj in gameObjList {
            gameObj.physicsBody =
                self.physicsEngine.updateCoordinates(
                    physicsBody: gameObj.physicsBody,
                    deltaTime: CGFloat(1 / framesPerSecond))
        }

        // Update dynamic bodies' velocities upon collision
        for gameObj in gameObjList {
            // Objects stay hit
            var isHit: Bool
            (gameObj.physicsBody, isHit) =
                self.physicsEngine.updateVelocities(
                    physicsBody: gameObj.physicsBody,
                    physicsBodyArr: gameObjList.map { $0.physicsBody },
                    deltaTime: CGFloat(1 / framesPerSecond))
            if isHit {
                gameObj.isHit = isHit
            }
        }

        // Update the coordinates to prevent overlapping
        for gameObj in gameObjList {
            gameObj.physicsBody =
                self.physicsEngine.updatePreventOverlapping(
                    physicsBody: gameObj.physicsBody,
                    physicsBodyArr: gameObjList.map { $0.physicsBody },
                    deltaTime: CGFloat(1 / framesPerSecond))
        }
    }

    func addObj(obj: GameObject) {
        gameObjList.append(obj)
    }

    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        gameObjList.contains(where: lambdaFunc)
    }

    func setBoundaries(bounds: CGRect) {
        self.bounds = bounds
    }

    private func removeLightedUpPegsConditionally(bounds: CGRect) {
        guard let ball = gameObjList.first(where: {
            $0.name == GameObject.Types.ball.rawValue
        }) else {
            removeLightedUpPegs()
            return
        }

        let minVelocity = 3.5
        if ball.physicsBody.velocity <= minVelocity {
            removeLightedUpPegs()
        }
    }

    private func removeLightedUpPegs() {
        for gameObj in gameObjList where gameObj.isHit {
            if gameObj.name == GameObject.Types.bluePeg.rawValue ||
                gameObj.name == GameObject.Types.orangePeg.rawValue {
                if gameObj.opacity >= 0 {
                    gameObj.opacity -= RATE_OF_FADING
                } else {
                    gameObjList = gameObjList.filter { $0 !== gameObj }
                }
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

        gameObjList = gameObjList.filter {
            outerBounds.contains($0.physicsBody.boundingBox)
        }
    }
}
