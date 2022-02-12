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
    let INITIAL_BALL_SPEED = 1_000.0

    init(objArr: [GameObject]) {
        gameRenderer = GameRenderer(gameObjList: objArr)

        cancellable = gameRenderer.publisher.sink { objArr in
            self.objArr = objArr
        }
    }
    
    func setBoundaries(bounds: CGRect) {
        createSideWalls(bounds: bounds)
        gameRenderer.setBoundaries(bounds: bounds)
    }

    func createSideWalls(bounds: CGRect) {
        gameRenderer.addObj(obj: Wall(coordinates: CGPoint(x: 1, y: 0), width: 1, height: bounds.height))
        gameRenderer.addObj(obj: Wall(coordinates: CGPoint(x: bounds.maxX-1, y: 0), width: 1, height: bounds.height))
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
                MAX_ANGLE,
                PhysicsEngineUtils.getVertAcuteAngle(from: cannonLoc, to: gestureLoc)
            )
        )

        return cannonAngle
    }

    func shootBall(from: CGPoint, to: CGPoint) {
        if gameRenderer.hasObj(lambdaFunc: {$0.imageName == Ball.imageName}) {
            return
        }
        
        let ball = Ball(coordinates: from)

        let angle = getCannonAngle(cannonLoc: from, gestureLoc: to)
        let unitVector = CGVector(dx: -sin(angle), dy: cos(angle))

        gameRenderer.addObj(obj: ball)
        ball.physicsBody.velocity = unitVector * INITIAL_BALL_SPEED
        print(ball.physicsBody.velocity)
    }

    func placeObj(at coordinates: CGPoint) {
        let bluePeg = Ball(coordinates: coordinates)

        gameRenderer.addObj(obj: bluePeg)
    }
    
    deinit {
        gameRenderer.stop()
    }
}
