//
//  SpookyPeg.swift
//  pegglegame
//
//  Created by kevin chua on 24/2/22.
//

import CoreGraphics

class SpookyPeg: Peg {
    static let imageName: String = "SpookyPeg"
    static let imageNameHit: String = "SpookyPegGlow"
    static let selectionObject: String = "AddSpookyPeg"

    init(coordinates: CGPoint, radius: Double) {
        super.init(
            coordinates: coordinates,
            radius: radius,
            imageName: SpookyPeg.imageName,
            imageNameHit: SpookyPeg.imageNameHit
        )
        super.setComponent(of: SpookyBallComponent())
    }

    init(coordinates: CGPoint) {
        super.init(
            coordinates: coordinates,
            imageName: SpookyPeg.imageName,
            imageNameHit: SpookyPeg.imageNameHit
        )
        super.setComponent(of: SpookyBallComponent())
    }
}
