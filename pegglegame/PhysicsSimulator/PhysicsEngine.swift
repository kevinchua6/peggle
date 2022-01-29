//
//  PhysicsEngine.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics

class PhysicsEngine {
    /*
     Credit to
     https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-distance-between-two-cgpoints
     for fast and easy distance calculation
     */
    static func CGPointDistanceSquared(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        (fromPoint.x - toPoint.x) * (fromPoint.x - toPoint.x) + (fromPoint.y - toPoint.y) * (fromPoint.y - toPoint.y)
    }

    static func CGPointDistance(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        sqrt(CGPointDistanceSquared(fromPoint: fromPoint, toPoint: toPoint))
    }

}
