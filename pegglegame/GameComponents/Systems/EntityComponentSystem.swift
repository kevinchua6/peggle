//
//  EntityComponentSystem.swift
//  pegglegame
//
//  Created by kevin chua on 23/2/22.
//

import Foundation

// Stores a mapping from every single entity's id to its components
/// ECS system adapted from:  http://vasir.net/blog/game-development/how-to-build-entity-component-system-in-javascript
struct EntityComponentSystem {
    // Each GameObject contains a mapping from the component it has to
    // it's respective data in each component
    private var components: [String: Component] = [:]

    func getComponent<T: Component>(component: T.Type) -> T? {
        components[String(describing: component)] as? T
    }

    mutating func setComponent<T: Component>(component: T) {
        components[String(describing: type(of: component))] = component
    }

    func getAllComponents() -> [Component] {
        Array(self.components.values)
    }
}
