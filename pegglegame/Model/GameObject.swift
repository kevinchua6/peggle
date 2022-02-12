//
//  Entity.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Foundation

class GameObject: Identifiable {
    // Types of game objects to be stored in the database
    enum Types: String {
        case bluepeg, orangepeg
    }

    var physicsBody: PhysicsBody
    var opacity: Double
    var imageName: String?
    var imageNameHit: String?
    var coordinates: CGPoint {
        get {
            physicsBody.coordinates
        }
        set {
            physicsBody.coordinates = newValue
        }
    }

    var isHit: Bool

    // Takes in a function that takes in what collides with it and returns
    var onCollide: (GameObject)?

    init(physicsBody: PhysicsBody,
         imageName: String? = nil,
         imageNameHit: String? = nil,
         onCollide: (GameObject)? = nil,
         isHit: Bool = false,
         opacity: Double = 1.0
    ) {
        self.physicsBody = physicsBody
        self.imageName = imageName
        self.imageNameHit = imageNameHit
        if imageNameHit == nil {
            self.imageNameHit = imageName
        }
        self.onCollide = onCollide
        self.isHit = isHit
        self.opacity = opacity
    }
}
