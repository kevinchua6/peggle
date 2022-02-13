//
//  PhysicsEngine.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Combine

class PhysicsEngine: ObservableObject {

    // TODO: make it a PhysicsBody instead
    var gameObjList: [GameObject]

    init(gameObjList: [GameObject]) {
        self.gameObjList = gameObjList
    }

    func update(deltaTime seconds: CGFloat) -> [GameObject] {
        var res: [GameObject] = []

        // Update bodies to next coordinates based on vel and accel
        for gameobject in gameObjList {
            let newPhysicsBody: PhysicsBody = gameobject.physicsBody.update(deltaTime: seconds)

            let newGameObj = GameObject(
                physicsBody: newPhysicsBody,
                name: gameobject.name,
                imageName: gameobject.imageName,
                imageNameHit: gameobject.imageNameHit,
                isHit: gameobject.isHit,
                opacity: gameobject.opacity
            )

            res.append(newGameObj)
        }

        // Update dynamic bodies' velocities upon collision
        for dynamicObject in res.filter({ $0.physicsBody.isDynamic }) {
            for gameObject in res {
                if dynamicObject === gameObject {
                    continue
                }

                if dynamicObject.physicsBody.isIntersecting(with: gameObject.physicsBody) {
                    dynamicObject.physicsBody.handleCollision(with: gameObject.physicsBody)

                    gameObject.isHit = true
                    dynamicObject.isHit = true
                }
            }
        }
        
        // Update the coordinates to prevent overlapping
        for dynamicObject in res.filter({ $0.physicsBody.isDynamic }) {
            dynamicObject.physicsBody.preventOverlapBodies()
        }

        res = fadeOutHitPegs(gameObjList: res)
        
        gameObjList = res
        return res
    }
    
    // TODO: remove
    func fadeOutHitPegs(gameObjList: [GameObject]) -> [GameObject] {
        var res: [GameObject] = []
        for gameObj in gameObjList {
            if gameObj.isHit {
                if gameObj.name == GameObject.Types.bluePeg.rawValue && gameObj.opacity >= 0 {
                    gameObj.opacity -= 0.005
                }
            }
            res.append(gameObj)
        }
        return res
    }
    

    func gameObjListSatisfy(lambdaFunc: (GameObject) -> Bool) {
        gameObjList = gameObjList.filter { lambdaFunc($0) }
    }

    func gameObjListFilter(lambdaFunc: (GameObject) -> Bool) -> [GameObject] {
        gameObjList.filter { lambdaFunc($0) }
    }

    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        gameObjList.contains(where: lambdaFunc)
    }

    func addObj(obj: GameObject) {
        gameObjList.append(obj)
    }

}
