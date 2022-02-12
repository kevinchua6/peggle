//
//  Square.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics

struct Rectangle: PhysicsBody {

    var coordinates: CGPoint
    var nextCoordinates: CGPoint
    var mass: CGFloat
    var hasGravity: Bool
    let gravity = 1.0

    var isDynamic: Bool

    // Physics stuff
    var velocity: CGVector
    var forces: [CGVector]

    var restitution: CGFloat

    let width: CGFloat
    let height: CGFloat

    // Bounding box to detect going out of screen
    var boundingBox: CGRect {
        // Set center of bounding box to center of Square
        CGRect(
            x: coordinates.x,
            y: coordinates.y,
            width: width,
            height: height
        )
    }

    init(
        coordinates: CGPoint,
        width: CGFloat,
        height: CGFloat,
        mass: CGFloat,
        isDynamic: Bool,
        forces: [CGVector] = [],
        velocity: CGVector = CGVector(dx: 0.0, dy: 0.0),
        restitution: CGFloat = 0.7,
        hasGravity: Bool = false
    ) {
        self.coordinates = coordinates
        self.nextCoordinates = coordinates
        self.width = width
        self.height = height
        self.mass = mass
        self.hasGravity = hasGravity
        self.isDynamic = isDynamic

        self.forces = forces
        self.velocity = velocity
        self.restitution = restitution
    }

    func update(deltaTime seconds: CGFloat) -> PhysicsBody {
        // If not dynamic, just return itself
        if !self.isDynamic {
            return self
        }

        var currForces = forces

        // Add a force downwards if theres gravity
        if hasGravity {
            currForces.append(CGVector(dx: 0.0, dy: 1_000))
        }

        // Get resultant force
        let resultantForce = currForces.reduce(CGVector.zero, +)
        let netAccel = resultantForce / mass

        // Next position
        let xIncrease = 0.5 * netAccel.dx * seconds * seconds
        let xCoord = coordinates.x + velocity.dx * seconds + xIncrease

        let yIncrease = 0.5 * netAccel.dy * seconds * seconds
        let yCoord = coordinates.y + velocity.dy * seconds + yIncrease

        let newCoord =
            CGPoint(x: xCoord,
                    y: yCoord
                )

        let newVelocity = CGVector(dx: velocity.dx + netAccel.dx * seconds, dy: velocity.dy + netAccel.dy * seconds)

        return Rectangle(
            coordinates: newCoord,
            width: width,
            height: height,
            mass: mass,
            isDynamic: isDynamic,
            forces: [], velocity: newVelocity,
            hasGravity: hasGravity
        )
    }
}

extension Rectangle {
    // swiftlint:disable force_cast
    // Because we know it is a Rectangle in the switch statement, it is okay to cast it to Square
    // I need to cast it because I need the same method signature to override isIntersecting
    func isIntersecting(with physicsBody: PhysicsBody) -> Bool {
        switch physicsBody {
        case is Circle:
            return isIntersecting(with: physicsBody as! Circle)
        case is Rectangle:
            return false
        default:
            return false
        }
    }

    func isIntersecting(with circle: Circle) -> Bool {
        // Do the more trivial version of collision first
        // For now, don't handle the corner case
        self.boundingBox.intersects(circle.boundingBox)
    }

    func isIntersecting(with physicsBodyArr: [PhysicsBody]) -> Bool {
        var isIntersectingAll = false
        for obj in physicsBodyArr {
            isIntersectingAll = isIntersectingAll || self.isIntersecting(with: obj)
        }
        return isIntersectingAll
    }

    mutating func handleCollision(with physicsBody: PhysicsBody) {
        switch physicsBody {
        case is Rectangle:
            handleCollision(with: physicsBody as! Rectangle)
        default:
            return
        }
    }

//    mutating func handleCollision(with Square: Rectangle) {
//        // The smaller the distance between the two, the larger the force vector
//        let distance = PhysicsEngineUtils.CGPointDistance(
//            from: self.coordinates, to: Square.coordinates
//        )
//
//        let totalWidth = self.radius + Square.radius
//
//        let collisionUnitVector = (self.coordinates - Square.coordinates) / distance
//
//        let relativeVelocity = self.velocity - Square.velocity
//
//        let minRestitution = min(self.restitution, Square.restitution)
//
//        let speed = abs(relativeVelocity * collisionUnitVector) * minRestitution
//
//        self.velocity = collisionUnitVector * speed
//
//        // When collide, shift the position back to prevent overlapping
//        let difference: CGFloat = totalWidth - distance + 1
//        let differenceVector: CGVector = collisionUnitVector * difference
//
//        self.coordinates += differenceVector
//    }

    mutating func preventOverlapBodies() {
        self.coordinates = self.nextCoordinates
    }
}
