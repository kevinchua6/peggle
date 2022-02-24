//
//  GameObject.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Foundation

class GameObject: Identifiable {
    // Types of game objects to be stored in the database
    enum Types: String {
        case bluePeg, orangePeg, ball, wall, block
    }

    // Allow easy identification of GameObjects
    let name: String

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
    
    var physicsBody: PhysicsBody {
        get {
            (self.components.getComponent(componentName: ComponentName.PhysicsComponent) as? PhysicsComponent)?.physicsBody
            ??
                RectangleBody(coordinates: coordinates, width: boundingBox.width, height: boundingBox.height, isDynamic: false)
        }
        set {
            self.components.setComponent(componentName: ComponentName.PhysicsComponent,
                                         as: PhysicsComponent(physicsBody: newValue)
            )
        }
    }

    var isHit: Bool
    
    // Each GameObject contains a mapping from the component it has to
    // it's respective data in each component
    var components: EntityComponentSystem

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
        self.imageName = imageName
        self.imageNameHit = imageNameHit
        self.isHit = isHit
        self.opacity = opacity
        self.components = EntityComponentSystem()

        self.components.setComponent(componentName: ComponentName.PhysicsComponent,
                                     as: PhysicsComponent(physicsBody: physicsBody)
                                     )
                                     
        if imageNameHit == nil {
            self.imageNameHit = imageName
        }
    }
}
