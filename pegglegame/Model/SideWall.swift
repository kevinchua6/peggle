//
//  Ball.swift
//  pegglegame
//
//  Created by kevin chua on 5/2/22.
//

import Foundation
import CoreGraphics

class SideWall: GameObject {
    let defaultRadius = 20.0
    // Side walls are invisible
    static let imageName: String = ""

    init(coordinates: CGPoint) {
        super.init(
            physicsBody: Rectangle(
                coordinates: coordinates,
                width: 1.0,
                height: 99.0,
                mass: 1.0,
                isDynamic: false
            ),
            imageName: Ball.imageName
        )
    }
}
