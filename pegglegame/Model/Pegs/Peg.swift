//
//  Peg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class Peg: GameObject {
    private let defaultRadius = 20.0

    init(coordinates: CGPoint, radius: Double, imageName: String, imageNameHit: String) {
        super.init(
            physicsBody: CircleBody(
                coordinates: coordinates,
                radius: radius,
                mass: 1.0,
                isDynamic: false,
                forces: [],
                velocity: CGVector(),
                hasGravity: false
            ), imageName: imageName, imageNameHit: imageNameHit
        )
        super.setComponent(of: ActivateOnHitComponent())
    }

    init(coordinates: CGPoint, imageName: String, imageNameHit: String) {
        super.init(
            physicsBody: CircleBody(
                coordinates: coordinates,
                radius: defaultRadius,
                mass: 1.0,
                isDynamic: false,
                forces: [],
                velocity: CGVector(),
                hasGravity: false
            ), imageName: imageName, imageNameHit: imageNameHit
        )
        super.setComponent(of: ActivateOnHitComponent())
    }
}
