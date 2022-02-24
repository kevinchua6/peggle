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
    
    var boundingBox: CGRect {
        get {
            self.physicsBody.boundingBox
        }
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

    var physicsBody: PhysicsBody {
        get {
            self.components.getComponent(component: PhysicsComponent.self)?.physicsBody ??
                RectangleBody(coordinates: CGPoint(x: 0.0, y: 0.0), width: 0.0, height: 0.0, isDynamic: false)
        }
        set {
            self.components.setComponent(component: PhysicsComponent(physicsBody: newValue))
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
        for component in self.components.components.values {
            component.reset()
        }
    }
}
