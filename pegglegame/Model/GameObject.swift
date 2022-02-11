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
    var imageName: String
    var coordinates: CGPoint {
        get {
            physicsBody.coordinates
        }
        set {
            physicsBody.coordinates = newValue
        }
    }

    init(physicsBody: PhysicsBody, imageName: String) {
        self.physicsBody = physicsBody
        self.imageName = imageName
    }

}
