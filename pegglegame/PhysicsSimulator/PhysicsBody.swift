//
//  PhysicsBody.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics

// Does not make sense to instantiate a Physics Body
protocol PhysicsBody {
    var coordinates: CGPoint { get set }

    // Will come in handy later when I build the physics engine
    var mass: CGFloat { get set }
    var hasGravity: Bool { get set }

//    var isDynamic: Bool { get set }

    // Detect collisions and overlaps
    func isIntersecting(with physicsBody: GameObject) -> Bool
    func isIntersecting(with entityArr: [GameObject]) -> Bool

    var boundingBox: CGRect { get }
    
    // Update body to next position
    func update(deltaTime seconds: CGFloat) -> PhysicsBody
}
