//
//  CircleBody.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics

struct CircleBody: PhysicsBody {

    var coordinates: CGPoint
    var nextCoordinates: CGPoint
    var mass: CGFloat
    var hasGravity: Bool
    let gravity = 1.0

    var radius: CGFloat

    var isDynamic: Bool

    // Physics stuff
    var velocity: CGVector
    var forces: [CGVector]

    var restitution: CGFloat

    // A small number to ensure that the velocity does not equal to 0
    let EPSILON = 1.0

    // Bounding box to detect going out of screen
    var boundingBox: CGRect {
        // Set center of bounding box to center of circle
        CGRect(
            x: coordinates.x - radius,
            y: coordinates.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }
    


    init(
        coordinates: CGPoint,
        radius: CGFloat,
        mass: CGFloat,
        isDynamic: Bool,
        forces: [CGVector],
        velocity: CGVector = CGVector(dx: 0.0, dy: 0.0),
        restitution: CGFloat = 0.8,
        hasGravity: Bool = false
    ) {
        self.coordinates = coordinates
        self.nextCoordinates = coordinates
        self.radius = radius
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
        let netAccel = CGVector(dx: resultantForce.dx / mass, dy: resultantForce.dy / mass)

        // Next position
        let xIncrease = 0.5 * netAccel.dx * seconds * seconds
        let xCoord = coordinates.x + velocity.dx * seconds + xIncrease

        let yIncrease = 0.5 * netAccel.dy * seconds * seconds
        let yCoord = coordinates.y + velocity.dy * seconds + yIncrease

        let newCoord =
            CGPoint(
                x: xCoord,
                y: yCoord
            )

        let newVelocity = CGVector(dx: velocity.dx + netAccel.dx * seconds, dy: velocity.dy + netAccel.dy * seconds)

        return CircleBody(
            coordinates: newCoord,
            radius: radius,
            mass: mass,
            isDynamic: isDynamic,
            forces: [],
            velocity: newVelocity,
            hasGravity: hasGravity
        )
    }
    
    mutating func setWidth(width: CGFloat) {
        self.radius = width / 2
    }
    
    mutating func setHeight(height: CGFloat) {
        self.radius = height / 2
    }
}

extension CircleBody {

    // swiftlint:disable force_cast
    // Because we know it is a CircleBody in the switch statement, it is okay to cast it to CircleBody
    // I need to cast it because I need the same method signature to override isIntersecting
    func isIntersecting(with physicsBody: PhysicsBody) -> Bool {
        switch physicsBody {
        case is RectangleBody:
            return isIntersecting(with: physicsBody as! RectangleBody)
        case is CircleBody:
            return isIntersecting(with: physicsBody as! CircleBody)
        default:
            return false
        }
    }

    func isIntersecting(with rectangle: RectangleBody) -> Bool {
        // Do the more trivial version of collision first
        // For now, don't handle the corner case
        self.boundingBox.intersects(rectangle.boundingBox)
    }

    func isIntersecting(with circle: CircleBody) -> Bool {
        // Find the distance between the two pegs
        // And check if the radius < the distance between the two

        // Compare the square as squareroot has a performance hit
        let distanceSquared = PhysicsEngineUtils.CGPointDistanceSquared(
            from: self.coordinates, to: circle.coordinates
        )

        let totalRadius: CGFloat = self.radius + circle.radius
        let totalRadiusSquared: CGFloat = totalRadius * totalRadius

        return distanceSquared < totalRadiusSquared
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
        case is CircleBody:
            handleCollision(with: physicsBody as! CircleBody)
        default:
            return
        }
    }

    mutating func handleCollision(with circle: CircleBody) {
        let distance = PhysicsEngineUtils.CGPointDistance(
            from: self.coordinates, to: circle.coordinates
        )

        let totalWidth = self.radius + circle.radius

        let collisionUnitVector = (self.coordinates - circle.coordinates) / distance
        
        // find the length of the dot product of the normal and the velocity
        // then multiply by the unit vector
        let dotProduct = abs(PhysicsEngineUtils.dotProduct(vector1: collisionUnitVector, vector2: self.velocity))

        let minRestitution = min(self.restitution, circle.restitution)

        self.velocity = collisionUnitVector * dotProduct * minRestitution

        // When collide, shift the position back to prevent overlapping
        let difference: CGFloat = totalWidth - distance
        let differenceVector: CGVector = collisionUnitVector * difference

        self.nextCoordinates += differenceVector
    }

    mutating func preventOverlapBodies() {
        self.coordinates = self.nextCoordinates
    }

    mutating func handleCollision(with rectangle: RectangleBody) {
        // The smaller the distance between the two, the larger the force vector
        let minRestitution = min(self.restitution, rectangle.restitution)

        let xdistance = self.coordinates.x - rectangle.coordinates.x
        let ydistance = self.coordinates.y - rectangle.coordinates.y

        let totalWidth = self.radius + rectangle.width / 2
        let totalHeight = self.radius + rectangle.height / 2

        let xdifference: CGFloat = totalWidth - abs(xdistance)
        let ydifference: CGFloat = totalHeight - abs(ydistance)

        // Do rotation in the future
        if rectangle.boundingBox.minY <= self.coordinates.y && self.coordinates.y <= rectangle.boundingBox.maxY {
            let differenceUnitVector = CGVector(dx: xdistance, dy: 0) / abs(xdistance)
            let differenceVector: CGVector = differenceUnitVector * xdifference

            self.velocity = CGVector(dx: -self.velocity.dx, dy: self.velocity.dy) * minRestitution
            self.nextCoordinates += differenceVector
        } else {
            let differenceUnitVector = CGVector(dx: 0, dy: ydistance) / abs(ydistance)
            let differenceVector: CGVector = differenceUnitVector * ydifference

            self.velocity = CGVector(dx: self.velocity.dx, dy: -self.velocity.dy) * minRestitution
            self.nextCoordinates += differenceVector
        }
    }
}
