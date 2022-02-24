//
//  PhysicsBody.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics

protocol PhysicsBody {
    var coordinates: CGPoint { get set }

    var velocity: CGVector { get set }
    var mass: CGFloat { get set }
    var hasGravity: Bool { get set }
    var forces: [CGVector] { get }

    mutating func applyForce(force: CGVector)

    var isDynamic: Bool { get }

    // Detect collisions and overlaps
    func isIntersecting(with physicsBody: PhysicsBody) -> Bool
    func isIntersecting(with physicsBodyArr: [PhysicsBody]) -> Bool

    var boundingBox: CGRect { get }

    // Update body to next position
    func update(deltaTime seconds: CGFloat) -> PhysicsBody

    mutating func setLength(length: CGFloat)

    // Update the coordinates to prevent overlapping
    mutating func preventOverlapBodies()

    // Adds the force when two bodies are colliding
    mutating func handleCollision(with: PhysicsBody)
}
