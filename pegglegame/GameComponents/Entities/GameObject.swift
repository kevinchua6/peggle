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
        case bluePeg, orangePeg, kaboomPeg, spookyPeg, ball, wall, block
    }

    var imageName: String?
    
    var coordinates: CGPoint {
        get {
            physicsBody.coordinates
        }
        set {
            physicsBody.coordinates = newValue
        }
    }

    // A gameobject can easily access it's physicsBody as every GameObject has a PhysicsBody
    var physicsBody: PhysicsBody {
        get {
            // A physicsBody definitely exists as it is added on instantiation and there is no way
            // to remove it from the EntityComponentSystem
            // However, to be more defensive we still return an empty body here
            self.getComponent(of: PhysicsComponent.self)?.physicsBody
                ?? RectangleBody(
                    coordinates: CGPoint(x: 0.0, y: 0.0), width: 0.0, height: 0.0, isDynamic: false
                )
        }
        set {
            self.setComponent(of: PhysicsComponent(physicsBody: newValue))
        }
    }
    
    var boundingBox: CGRect {
        get {
            self.physicsBody.boundingBox
        }
    }

    // Each GameObject contains a mapping from the component it has to
    // it's respective data in each component
    var components: EntityComponentSystem

    init(
        physicsBody: PhysicsBody,
        imageName: String? = nil
    ) {
        self.imageName = imageName
        self.components = EntityComponentSystem()
        self.components.setComponent(component: PhysicsComponent(physicsBody: physicsBody))
    }

    func getComponent<T: Component>(of type: T.Type) -> T? {
        components.getComponent(component: type)
    }

    func setComponent<T: Component>(of type: T) {
        components.setComponent(component: type)
    }

    func hasComponent<T: Component>(of type: T.Type) -> Bool {
        components.getComponent(component: type) != nil
    }
    
    func reset() {
        for component in self.components.getAllComponents() {
            component.reset()
        }
    }
}

// Commonly used components: Activate on hit components
extension GameObject {
    var isHit: Bool {
        get {
            self.getComponent(of: ActivateOnHitComponent.self)?.isHit
                ?? false
        }
    }
    
    var isActivated: Bool {
        get {
            self.getComponent(of: ActivateOnHitComponent.self)?.isActivated
                ?? false
        }
    }
    
    func activate() {
        self.getComponent(of: ActivateOnHitComponent.self)?.activate()
    }
}
