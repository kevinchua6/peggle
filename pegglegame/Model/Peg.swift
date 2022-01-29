//
//  Peg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class Peg: GameObject {
    let defaultRadius = 20.0

    init(coordinates: CGPoint, radius: Double, imageName: String) {
        super.init(
            physicsBody: Circle(
                coordinates: coordinates, radius: radius, mass: 1.0, hasGravity: false
            ), imageName: imageName
        )
    }

    init(coordinates: CGPoint, imageName: String) {
        super.init(
            physicsBody: Circle(
                coordinates: coordinates, radius: defaultRadius, mass: 1.0, hasGravity: false
            ), imageName: imageName
        )
    }
}

extension Peg {
    enum Color: String {
        case blue, orange
    }
}
