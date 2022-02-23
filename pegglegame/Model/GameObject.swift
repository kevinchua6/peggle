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
        case bluePeg, orangePeg, ball, wall
    }

    // Allow easy identification of GameObjects
    let name: String

    var physicsBody: PhysicsBody
    
    var boundingBox: CGRect {
        get {
            self.physicsBody.boundingBox
        }
    }
    
    
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

    init(
        physicsBody: PhysicsBody,
        name: String = "",
        imageName: String? = nil,
        imageNameHit: String? = nil,
        onCollide: (GameObject)? = nil,
        isHit: Bool = false,
        opacity: Double = 1.0
    ) {
        self.name = name
        self.physicsBody = physicsBody
        self.imageName = imageName
        self.imageNameHit = imageNameHit
        self.isHit = isHit
        self.opacity = opacity

        if imageNameHit == nil {
            self.imageNameHit = imageName
        }
    }
}
