//
//  TriangleBlock.swift
//  pegglegame
//
//  Created by kevin chua on 23/2/22.
//

import Foundation
import CoreGraphics

class TriangleBlock: GameObject {
    static let imageName: String = "TriangleBlock"
    let originalCoordinates: CGPoint
    var springRadius: CGFloat

    init(coordinates: CGPoint, springRadius: CGFloat = 40.0, radius: CGFloat) {
        self.springRadius = springRadius
        self.originalCoordinates = coordinates
        super.init(
            physicsBody: CircleBody(
                coordinates: coordinates,
                radius: radius,
                mass: 1.0,
                isDynamic: true,
                forces: [],
                velocity: CGVector(),
                hasGravity: false
            ),
            imageName: TriangleBlock.imageName
        )
        super.setComponent(of: OscillatingComponent())
    }
}
