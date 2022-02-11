//
//  OrangePeg.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import CoreGraphics

class OrangePeg: Peg {
    static let imageName: String = "OrangePeg"
    static let selectionObject: String = "AddOrangePeg"

    init(coordinates: CGPoint, radius: Double) {
        super.init(coordinates: coordinates, radius: radius, imageName: OrangePeg.imageName)
    }

    init(coordinates: CGPoint) {
        super.init(coordinates: coordinates, imageName: OrangePeg.imageName)
    }
}
