//
//  Bucket.swift
//  pegglegame
//
//  Created by kevin chua on 25/2/22.
//

import Foundation
import CoreGraphics

class Bucket: GameObject {
    static let imageName: String = "Bucket"

    init(coordinates: CGPoint, radius: CGFloat) {
        super.init(
            physicsBody: CircleBody(
                coordinates: coordinates,
                radius: radius,
                mass: 1.0,
                isDynamic: true,
                forces: [],
                velocity: CGVector(dx: 100.0, dy: 0),
                restitution: 1.0,
                hasGravity: false
            ),
            imageName: Bucket.imageName
        )
        super.setComponent(of: BucketComponent())
    }
}
