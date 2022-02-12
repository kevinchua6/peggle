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
        removeObjOutsideBoundaries()
        removeLightedUpPegs()
        return self.physicsEngine.update(deltaTime: CGFloat(1 / framesPerSecond))
    }
    
    func addObj(obj: GameObject) {
        physicsEngine.addObj(obj: obj)
    }
    
    func setBoundaries(bounds: CGRect) {
        self.bounds = bounds
    }
    
    private func removeLightedUpPegs() {
        physicsEngine.gameObjListSatisfy(lambdaFunc: {
            !$0.isHit
        })
    }
    
    private func removeObjOutsideBoundaries() {
        guard let myBounds = self.bounds else {
            return
        }
        
        physicsEngine.gameObjListSatisfy(lambdaFunc: {
            myBounds.contains($0.physicsBody.boundingBox)
        })
    }
}
