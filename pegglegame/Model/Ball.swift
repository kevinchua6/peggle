//
//  Ball.swift
//  pegglegame
//
//  Created by kevin chua on 5/2/22.
//

import Foundation
import CoreGraphics

// For now, it's basically a blue peg but dynamic
class Ball: GameObject {
    let defaultRadius = 20.0
    static let imageName: String = "BluePeg"

    init(coordinates: CGPoint) {
        super.init(
            physicsBody: Circle(
                coordinates: coordinates,
                radius: defaultRadius,
                mass: 1.0,
                hasGravity: true,
                isDynamic: true,
                velocity: CGVector(),
                forces: []
            ),
            imageName: Ball.imageName
        )
    }

//    init(coordinates: CGPoint, imageName: String) {
//        super.init(
//            physicsBody: Circle(
//                coordinates: coordinates, radius: defaultRadius, mass: 1.0, hasGravity: true, isDynamic: true, velocity: CGVector(), forces: []
//            ), imageName: imageName
//        )
//    }
}
