//
//  Peg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class Peg: GameObject {
    let defaultRadius = 20.0

    init(coordinates: CGPoint, radius: Double, imageName: String, imageNameHit: String) {
        super.init(
            physicsBody: Circle(
                coordinates: coordinates, radius: radius, mass: 1.0, hasGravity: false, isDynamic: false, velocity: CGVector(), forces: []
            ), imageName: imageName, imageNameHit: imageNameHit, isHit: false
        )
    }

    init(coordinates: CGPoint, imageName: String, imageNameHit: String) {
        super.init(
            physicsBody: Circle(
                coordinates: coordinates, radius: defaultRadius, mass: 1.0, hasGravity: false, isDynamic: false, velocity: CGVector(), forces: []
            ), imageName: imageName, imageNameHit: imageNameHit, isHit: false
        )
    }
}

extension Peg {
    enum Color: String {
        case blue, orange
    }
}
