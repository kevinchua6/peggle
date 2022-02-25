//
//  BucketComponent.swift
//  pegglegame
//
//  Created by kevin chua on 25/2/22.
//

import Foundation
import CoreGraphics

class BucketComponent: Component {
    var freeBallMsgShown: Bool

    init() {
        freeBallMsgShown = false
    }

    func showMsg() {
        freeBallMsgShown = true
    }

    func hideMsg() {
        freeBallMsgShown = false
    }

    func updateVelocity(gameObj: GameObject, objArr: [GameObject], physicsEngine: PhysicsEngine) -> PhysicsBody {
        var newPhysicsBody = gameObj.physicsBody
        (newPhysicsBody, _) =
            physicsEngine.updateVelocities(
                physicsBody: gameObj.physicsBody,
                physicsBodyArr: objArr.filter({ $0.hasComponent(of: WallComponent.self) }).map { $0.physicsBody },
                deltaTime: CGFloat(1 / 60.0)
            )

        return newPhysicsBody
    }

    func removeBall(bucket: GameObject, objArr: [GameObject]) -> [GameObject] {
        var newObjArr: [GameObject] = objArr
        // check if a ball exists a few inches above the bucket to remove it
        // then create a free ball
        for ball in objArr.filter({ $0.hasComponent(of: CannonBallComponent.self) }) {
            if ball.coordinates.y >= bucket.coordinates.y - 45
                && ball.coordinates.x > bucket.coordinates.x - 28
                && ball.coordinates.x < bucket.coordinates.x + 28 {
                newObjArr = objArr.filter { $0 !== ball }
                showMsg()
            }
        }
        return newObjArr
    }

    func reset() {
        freeBallMsgShown = false
    }
}
