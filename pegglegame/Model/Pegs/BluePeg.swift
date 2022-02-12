//
//  BluePeg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class BluePeg: Peg {
    static let imageName: String = "BluePeg"
    static let imageNameHit: String = "BluePegGlow"
    static let selectionObject: String = "AddBluePeg"

    init(coordinates: CGPoint, radius: Double, name: String) {
        super.init(
            coordinates: coordinates,
            radius: radius,
            imageName: BluePeg.imageName,
            imageNameHit: BluePeg.imageNameHit,
            name: name
        )
    }

    init(coordinates: CGPoint, name: String) {
        super.init(
            coordinates: coordinates,
            imageName: BluePeg.imageName,
            imageNameHit: BluePeg.imageNameHit,
            name: name
        )
    }
}
