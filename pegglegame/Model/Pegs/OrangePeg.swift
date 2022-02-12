//
//  OrangePeg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class OrangePeg: Peg {
    static let imageName: String = "OrangePeg"
    static let imageNameHit: String = "OrangePegGlow"
    static let selectionObject: String = "AddOrangePeg"

    init(coordinates: CGPoint, radius: Double, name: String) {
        super.init(
            coordinates: coordinates,
            radius: radius,
            imageName: OrangePeg.imageName,
            imageNameHit: OrangePeg.imageNameHit,
            name: name
        )
    }

    init(coordinates: CGPoint, name: String) {
        super.init(
            coordinates: coordinates,
            imageName: OrangePeg.imageName,
            imageNameHit: OrangePeg.imageNameHit,
            name: name
        )
    }
}
