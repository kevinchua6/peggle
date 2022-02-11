//
//  StartGameViewModel.swift
//  pegglegame
//
//  Created by kevin chua on 2/2/22.
//

import Foundation
import CoreGraphics
import Combine

class StartGameViewModel: ObservableObject {

    private var cancellable: AnyCancellable?

    @Published var objArr: [GameObject] = []

    var gameRenderer: GameRenderer

    let MAX_ANGLE = Double.pi / 2

    init(objArr: [GameObject]) {
        gameRenderer = GameRenderer(gameObjList: objArr)

        cancellable = gameRenderer.publisher.sink { objArr in
            self.objArr = objArr
        }

        for wall in createWalls() {
            gameRenderer.addObj(obj: wall)
        }
    }

    func createWalls() -> [GameObject] {
        [
//            SideWall(coordinates: CGPoint(x: 0, y: 0)),
            SideWall(coordinates: CGPoint(x: 0, y: 0))
        ]
    }

    func getCannonAngle(cannonLoc: CGPoint, gestureLoc: CGPoint) -> CGFloat {
        // only detect the bottom two quadrants
        if gestureLoc.y < cannonLoc.y {
            if gestureLoc.x > cannonLoc.x {
                return -MAX_ANGLE
            } else {
                return MAX_ANGLE
            }
        }

        // keep cannon between two values
        let cannonAngle = max(
            -MAX_ANGLE, min(
                MAX_ANGLE, PhysicsEngineUtils.getVertAcuteAngle(from: cannonLoc, to: gestureLoc)
            )
        )

        return cannonAngle
    }

    func shootBall(from: CGPoint, to: CGPoint) {
        let ball = Ball(coordinates: from)
        
        let angle = getCannonAngle(cannonLoc: from, gestureLoc: to)
        let unitVector = CGVector(dx: -sin(angle), dy: cos(angle))

        let speed = 1_000.0

        gameRenderer.addObj(obj: ball)
        ball.physicsBody.velocity = unitVector * speed
        print(ball.physicsBody.velocity)

    }

    func placeObj(at coordinates: CGPoint) {
        let bluePeg = Ball(coordinates: coordinates)

//        objArr.append(bluePeg)
        gameRenderer.addObj(obj: bluePeg)
    }
}
