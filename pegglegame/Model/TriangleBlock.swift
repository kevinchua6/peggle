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
    var springRadius: CGFloat

    init(coordinates: CGPoint, name: String, springRadius: CGFloat = 40.0) {
        self.springRadius = springRadius
        super.init(
            physicsBody: CircleBody(
                coordinates: coordinates,
                radius: 20.0,
                mass: 1.0,
                isDynamic: true,
                forces: [],
                velocity: CGVector(),
                hasGravity: false
            ),
            name: name,
            imageName: TriangleBlock.imageName
        )
    }
}
