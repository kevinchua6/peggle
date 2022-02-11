//
//  Ball.swift
//  pegglegame
//
//  Created by kevin chua on 5/2/22.
//

import Foundation
import CoreGraphics

class SideWall: GameObject {
    init(coordinates: CGPoint, height: CGFloat) {
        super.init(
            physicsBody: Rectangle(
                coordinates: coordinates,
                width: 0.1,
                height: height,
                mass: 1.0,
                isDynamic: false
            ),
            imageName: nil
        )
    }
}
