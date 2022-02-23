//
//  Ball.swift
//  pegglegame
//
//  Created by kevin chua on 5/2/22.
//

import Foundation
import CoreGraphics

class Wall: GameObject {
    init(coordinates: CGPoint, width: CGFloat, height: CGFloat, name: String) {
        super.init(
            physicsBody: RectangleBody(
                coordinates: coordinates,
                width: width,
                height: height,
                mass: 1.0,
                isDynamic: false
            ),
            name: name,
            imageName: nil
        )
    }
}
