//
//  KaboomBallComponent.swift
//  pegglegame
//
//  Created by kevin chua on 24/2/22.
//

import Foundation
import CoreGraphics

class KaboomPegComponent: Component {
    private let KABOOM_RADIUS = 20_000.0
    private let KABOOM_MAGNITUDE = 200.0

    func explodeSurroundingPegs(kaboomPeg: GameObject, objArr: [GameObject], scoreEngine: ScoreEngine) -> [GameObject] {
        var newObjArr: [GameObject] = []
        for obj in objArr {
            if obj !== kaboomPeg && PhysicsEngineUtils.CGPointDistanceSquared(
                from: kaboomPeg.coordinates, to: obj.coordinates
            ) <= KABOOM_RADIUS {
                if obj.hasComponent(of: CannonBallComponent.self) {
                    // launch it away
                    let distanceVector = obj.coordinates - kaboomPeg.coordinates
                    let unitVector = PhysicsEngineUtils.getUnitVector(vector: distanceVector)
                    let resultantVelocity: CGVector = obj.physicsBody.velocity + unitVector * KABOOM_MAGNITUDE

                    var velocityMagnitude = PhysicsEngineUtils.getMagnitude(vector: resultantVelocity)

                    // cap velocity
                    velocityMagnitude = min(velocityMagnitude, PhysicsEngine.MAX_VELOCITY)

                    obj.physicsBody.velocity =
                        PhysicsEngineUtils.getUnitVector(
                            vector: obj.physicsBody.velocity
                        ) * velocityMagnitude

                }

                if obj.getComponent(of: ActivateOnHitComponent.self)?.isHit ?? false {
                    if obj.hasComponent(of: OrangePegComponent.self) {
                        scoreEngine.noOrangePegHit += 1
                    } else if obj.hasComponent(of: PegComponent.self) {
                        scoreEngine.noPegHit += 1
                    }
                }

                obj.getComponent(of: ActivateOnHitComponent.self)?.isHit = true
                obj.getComponent(of: ScoreComponent.self)?.show()
            }

            newObjArr.append(obj)
        }
        return newObjArr
    }

    func reset() {
    }
}
