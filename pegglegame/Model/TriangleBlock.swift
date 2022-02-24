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

    init(coordinates: CGPoint, name: String) {
        super.init(
            physicsBody: TriangleBody(
                coordinates: coordinates,
                width: 20.0,
                height: 20.0,
                mass: 1.0,
                isDynamic: false,
                forces: [],
                velocity: CGVector(),
                hasGravity: false
            ),
            name: name,
            imageName: TriangleBlock.imageName
        )
    }
}
