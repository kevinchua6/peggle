//
//  Ball.swift
//  pegglegame
//
//  Created by kevin chua on 5/2/22.
//

import Foundation
import CoreGraphics

class Ball: GameObject {
    let defaultRadius = 20.0
    static let imageName: String = "Ball"

    init(coordinates: CGPoint) {
        super.init(
            physicsBody: CircleBody(
                coordinates: coordinates,
                radius: defaultRadius,
                mass: 1.0,
                isDynamic: true,
                forces: [],
                velocity: CGVector(),
                hasGravity: true
            ),
            imageName: Ball.imageName
        )

        super.setComponent(of: CannonBallComponent())
        super.setComponent(of: SpookyBallComponent())
    }
}
