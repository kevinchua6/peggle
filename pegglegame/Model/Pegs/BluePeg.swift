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

    init(coordinates: CGPoint, radius: Double) {
        super.init(
            coordinates: coordinates,
            radius: radius,
            imageName: BluePeg.imageName,
            imageNameHit: BluePeg.imageNameHit
        )
        super.setComponent(of: BluePegComponent())
        super.setComponent(of: ScoreComponent(score: 100))
    }

    init(coordinates: CGPoint) {
        super.init(
            coordinates: coordinates,
            imageName: BluePeg.imageName,
            imageNameHit: BluePeg.imageNameHit
        )
        super.setComponent(of: BluePegComponent())
        super.setComponent(of: ScoreComponent(score: 100))
    }
}
