//
//  PhysicsEngine.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Combine

class PhysicsEngine: ObservableObject {

    var gameObjList: [GameObject]

    init(gameObjList: [GameObject]) {
        self.gameObjList = gameObjList
    }

    func update(deltaTime seconds: CGFloat) -> [GameObject] {
        var res: [GameObject] = []

        // Update bodies to next coordinates based on vel and accel
        for gameobject in gameObjList {
            let newPhysicsBody: PhysicsBody = gameobject.physicsBody.update(deltaTime: seconds)

            let newGameObj = GameObject(physicsBody: newPhysicsBody, imageName: gameobject.imageName)

            res.append(newGameObj)
        }

        // Update dynamic bodies' velocities upon collision
        for dynamicObject in res.filter({ $0.physicsBody.isDynamic }) {
            for gameObject in res {
                if dynamicObject === gameObject {
                    continue
                }

                if dynamicObject.physicsBody.isIntersecting(with: gameObject) {
                    dynamicObject.physicsBody.handleCollision(with: gameObject.physicsBody)
                }
            }
        }

        // Update the coordinates to prevent overlapping
        for dynamicObject in res.filter({ $0.physicsBody.isDynamic }) {
            dynamicObject.physicsBody.preventOverlapBodies()
        }

        gameObjList = res
        return res
    }

    func addObj(obj: GameObject) {
        gameObjList.append(obj)
    }
}
