//
//  NonsenseComponent.swift
//  pegglegame
//
//  Created by kevin chua on 26/2/22.
//

import Foundation
import CoreGraphics

class NonsenseComponent: Component {
    func reset() {
    }

    static func replacePegWithBall(gameObj: GameObject, objArr: [GameObject]) -> [GameObject] {
        guard !gameObj.hasComponent(of: WallComponent.self) else {
            return objArr
        }

        var newObjArr = objArr

        newObjArr = newObjArr.filter({ !($0 === gameObj) })
        let newBall = Ball(coordinates: gameObj.coordinates, radius: gameObj.boundingBox.width / 2)

        newBall.physicsBody.velocity = -gameObj.physicsBody.velocity
        newObjArr.append(
            newBall
        )

        return newObjArr
    }

}
