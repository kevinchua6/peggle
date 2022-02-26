//
//  TriangleBody.swift
//  pegglegame
//
//  Created by kevin chua on 23/2/22.
//

import CoreGraphics

struct TriangleBody: PhysicsBody {

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

    var width: CGFloat
    var height: CGFloat

    var v1: CGPoint {
        CGPoint(x: coordinates.x, y: coordinates.y + width)
    }
    var v2: CGPoint {
        CGPoint(x: coordinates.x + height, y: coordinates.y + width)
    }
    var v3: CGPoint {
        CGPoint(x: coordinates.x - height, y: coordinates.y + width)
    }

    // Bounding box to detect going out of screen
    var boundingBox: CGRect {
        // Set center of bounding box to center of Triangle
        CGRect(
            x: coordinates.x - width,
            y: coordinates.y - height,
            width: width * 2,
            height: height * 2
        )
    }

    init(
        coordinates: CGPoint,
        width: CGFloat,
        height: CGFloat,
        isDynamic: Bool,
        mass: CGFloat = 1.0,
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
        let resultantForce = currForces.reduce(CGVector.zero, { CGVector(dx: $0.dx + $1.dx, dy: $0.dy + $1.dy) })
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

        return RectangleBody(
            coordinates: newCoord,
            width: width,
            height: height,
            isDynamic: isDynamic,
            forces: [],
            mass: mass,
            velocity: newVelocity,
            hasGravity: hasGravity
        )
    }

    mutating func setLength(length: CGFloat) {
        self.width = length / 2
        self.height = length / 2
    }

    mutating func applyForce(force: CGVector) {
        forces.append(force)
    }

    mutating func removeForces() {
        forces = []
    }
}

extension TriangleBody {
    // swiftlint:disable force_cast
    // Because we know it is a Rectangle in the switch statement, it is okay to cast it to Square
    // I need to cast it because I need the same method signature to override isIntersecting
    func isIntersecting(with physicsBody: PhysicsBody) -> Bool {
        switch physicsBody {
        case is CircleBody:
            return isIntersecting(with: physicsBody as! CircleBody)
        case is RectangleBody:
            return false
        default:
            return false
        }
    }

    func isIntersecting(with circle: CircleBody) -> Bool {
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
        case is RectangleBody:
            handleCollision(with: physicsBody as! RectangleBody)
        default:
            return
        }
    }

    mutating func preventOverlapBodies() {
        self.coordinates = self.nextCoordinates
    }
}
