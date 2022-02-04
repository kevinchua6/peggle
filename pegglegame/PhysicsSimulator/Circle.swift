//
//  Circle.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics

struct Circle: PhysicsBody {

    var coordinates: CGPoint
    var mass: CGFloat
    var hasGravity: Bool

    var radius: CGFloat
    
    var isDynamic: Bool
    
    // Physics stuff
    var velocity: CGVector
    var forces: [CGVector]

    // Bounding box to detect going out of screen
    var boundingBox: CGRect {
        // Set center of bounding box to center of circle
        CGRect(x: coordinates.x - radius, y: coordinates.y - radius, width: radius * 2, height: radius * 2)
    }

    init(coordinates: CGPoint, radius: CGFloat, mass: CGFloat, hasGravity: Bool, isDynamic: Bool, velocity: CGVector, forces: [CGVector]) {
        self.coordinates = coordinates
        self.radius = radius
        self.mass = mass
        self.hasGravity = hasGravity
        self.isDynamic = isDynamic
        
        self.forces = forces
        self.velocity = velocity
    }
    
    func update(deltaTime seconds: CGFloat) -> PhysicsBody {
        // If not dynamic, just return itself
        if !self.isDynamic {
            return self
        }
        
        var currForces = forces
        
        // Add a force downwards if theres gravity
        if hasGravity {
            currForces.append(CGVector(dx: 0, dy: 100))
        }
        
        // Get resultant force
        let resultantForce = currForces.reduce(CGVector.zero, {CGVector(dx: $0.dx + $1.dx, dy: $0.dy + $1.dy)})
        let netAccel = CGVector(dx: resultantForce.dx / mass, dy: resultantForce.dy / mass)
        
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
        
        return Circle(coordinates: newCoord, radius: radius, mass: mass, hasGravity: hasGravity, isDynamic: isDynamic, velocity: newVelocity, forces: [])
    }
}

extension Circle {
    // swiftlint:disable force_cast
    // Because we know it is a Circle in the switch statement, it is okay to cast it to Circle
    // I need to cast it because I need the same method signature to override isIntersecting
    func isIntersecting(with gameObject: GameObject) -> Bool {
        let physicsBody = gameObject.physicsBody
        switch physicsBody {
        case is Circle:
            return isIntersecting(with: physicsBody as! Circle)
        default:
            return false
        }
    }

    func isIntersecting(with circle: Circle) -> Bool {
        // Find the distance between the two pegs
        // And check if the radius < the distance between the two

        // Compare the square as squareroot has a performance hit
        let distanceSquared = PhysicsEngine.CGPointDistanceSquared(
            fromPoint: self.coordinates, toPoint: circle.coordinates
        )

        let totalRadius: CGFloat = self.radius + circle.radius
        let totalRadiusSquared: CGFloat = totalRadius * totalRadius

        return distanceSquared < totalRadiusSquared
    }

    func isIntersecting(with entityArr: [GameObject]) -> Bool {
        var isIntersectingAll = false
        for obj in entityArr {
            isIntersectingAll = isIntersectingAll || self.isIntersecting(with: obj)
        }
        return isIntersectingAll
    }
}
