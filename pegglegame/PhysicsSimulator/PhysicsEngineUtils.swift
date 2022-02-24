//
//  PhysicsEngineUtils.swift
//  pegglegame
//
//  Created by kevin chua on 10/2/22.
//

import CoreGraphics

class PhysicsEngineUtils {
    static func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y

        return dx * dx + dy * dy
    }

    static func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = from.x - to.x
        let dy = from.y - to.y

        return sqrt(dx * dx + dy * dy)
    }

    static func getVertAcuteAngle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
        atan((dest.x - source.x) / (source.y - dest.y))
    }

    static func getHorizAcuteAngle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
        atan((dest.y - source.y) / (source.x - dest.x))
    }

    static func dotProduct(vector1: CGVector, vector2: CGVector) -> CGFloat {
        vector1.dx * vector2.dx + vector1.dy * vector2.dy
    }

    static func getUnitVector(vector: CGVector) -> CGVector {
        let magnitude = getMagnitude(vector: vector)
        return vector / magnitude
    }
    
    static func getMagnitude(vector: CGVector) -> CGFloat {
        vector * 1
    }
}
