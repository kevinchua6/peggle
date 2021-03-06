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

    init(coordinates: CGPoint, radius: Double) {
        super.init(
            coordinates: coordinates,
            radius: radius,
            imageName: OrangePeg.imageName,
            imageNameHit: OrangePeg.imageNameHit
        )
        super.setComponent(of: OrangePegComponent())
        super.setComponent(of: ScoreComponent(score: 150))
    }

    init(coordinates: CGPoint) {
        super.init(
            coordinates: coordinates,
            imageName: OrangePeg.imageName,
            imageNameHit: OrangePeg.imageNameHit
        )
        super.setComponent(of: OrangePegComponent())
        super.setComponent(of: ScoreComponent(score: 150))
    }
}
