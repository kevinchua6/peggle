//
//  BluePeg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class BluePeg: Peg {
    static let imageName: String = "BluePeg"
    static let selectionObject: String = "AddBluePeg"

    init(coordinates: CGPoint, radius: Double) {
        super.init(coordinates: coordinates, radius: radius, imageName: BluePeg.imageName)
    }

    init(coordinates: CGPoint) {
        super.init(coordinates: coordinates, imageName: BluePeg.imageName)
    }
}
