//
//  KaboomPeg.swift
//  pegglegame
//
//  Created by kevin chua on 24/2/22.
//

import CoreGraphics

class KaboomPeg: Peg {
    static let imageName: String = "KaboomPeg"
    static let imageNameHit: String = "KaboomPegGlow"
    static let selectionObject: String = "AddKaboomPeg"

    init(coordinates: CGPoint, radius: Double) {
        super.init(
            coordinates: coordinates,
            radius: radius,
            imageName: KaboomPeg.imageName,
            imageNameHit: KaboomPeg.imageNameHit
        )
        super.setComponent(of: KaboomPegComponent())
    }

    init(coordinates: CGPoint) {
        super.init(
            coordinates: coordinates,
            imageName: KaboomPeg.imageName,
            imageNameHit: KaboomPeg.imageNameHit
        )
        super.setComponent(of: KaboomPegComponent())
    }
}
