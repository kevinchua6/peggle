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

class GameEngine {
    private let physicsEngine: PhysicsEngine
    private var bounds: CGRect?

    private let framesPerSecond: CGFloat = 60

    init(gameObjList: [GameObject]) {
        self.physicsEngine = PhysicsEngine(gameObjList: gameObjList)
    }

    func update() -> [GameObject] {
        if let myBounds = self.bounds {
            removeObjOutsideBoundaries(bounds: myBounds)
//            removeLightedUpPegsConditionally(bounds: myBounds)
        }

        return self.physicsEngine.update(deltaTime: CGFloat(1 / framesPerSecond))
    }

    func addObj(obj: GameObject) {
        physicsEngine.addObj(obj: obj)
    }

    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        physicsEngine.hasObj(lambdaFunc: lambdaFunc)
    }

    func setBoundaries(bounds: CGRect) {
        self.bounds = bounds
    }

    private func removeLightedUpPegsConditionally(bounds: CGRect) {
        guard let ball = physicsEngine.gameObjListFilter(lambdaFunc: {
            $0.name == GameObject.Types.ball.rawValue
        }).first else {
            removeLightedUpPegs()
            return
        }

        let minVelocity = 5.0
        if ball.physicsBody.velocity <= minVelocity {
            removeLightedUpPegs()
        }
    }

    private func removeLightedUpPegs() {
        physicsEngine.gameObjListSatisfy(lambdaFunc: {
            !$0.isHit || !(
                $0.name == GameObject.Types.bluePeg.rawValue ||
                $0.name == GameObject.Types.orangePeg.rawValue
            )
        })
    }

    private func removeObjOutsideBoundaries(bounds: CGRect) {
        let addiLength = 200.0
        // Remove pegs only a certain amount away from the bounds
        let outerBounds = CGRect(
            x: bounds.minX - addiLength,
            y: bounds.minY - addiLength,
            width: bounds.width + 2 * addiLength,
            height: bounds.height + 2 * addiLength
        )

        physicsEngine.gameObjListSatisfy(lambdaFunc: {
            outerBounds.contains($0.physicsBody.boundingBox)
        })
    }
}
