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

    var velocity: CGVector { get set }
    var mass: CGFloat { get set }
    var hasGravity: Bool { get set }
    var forces: [CGVector] { get }

    var isDynamic: Bool { get }

//    var isDynamic: Bool { get set }

    // Detect collisions and overlaps
    func isIntersecting(with physicsBody: GameObject) -> Bool
    func isIntersecting(with entityArr: [GameObject]) -> Bool

    var boundingBox: CGRect { get }

    // Update body to next position
    func update(deltaTime seconds: CGFloat) -> PhysicsBody

    // Update the coordinates to prevent overlapping
    mutating func preventOverlapBodies()

    // Adds the force when two bodies are colliding
    mutating func handleCollision(with: PhysicsBody)
}
