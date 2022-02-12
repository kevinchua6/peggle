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
            removeLightedUpPegs(bounds: myBounds)
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
    
    private func removeLightedUpPegs(bounds: CGRect) {
        if !physicsEngine.gameObjList.contains(where: { $0.imageName == Ball.imageName }) {
            
            
            physicsEngine.gameObjListSatisfy(lambdaFunc: {
                !$0.isHit || !($0.imageName == BluePeg.imageName || $0.imageName == OrangePeg.imageName)
            })
        }
    }
    
    private func removeObjOutsideBoundaries(bounds: CGRect) {
        physicsEngine.gameObjListSatisfy(lambdaFunc: {
            bounds.contains($0.physicsBody.boundingBox)
        })
    }
}
