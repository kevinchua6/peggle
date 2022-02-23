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
    var components: [ComponentName : Component] = [:]
    
    func getComponent(componentName: ComponentName) -> Component? {
        components[componentName]
    }
    
    mutating func setComponent(componentName: ComponentName, as component: Component) {
        components[componentName] = component
    }
}
