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

    // Bounding box to detect going out of screen
    var boundingBox: CGRect {
        // Set center of bounding box to center of circle
        CGRect(x: coordinates.x - radius, y: coordinates.y - radius, width: radius * 2, height: radius * 2)
    }

    init(coordinates: CGPoint, radius: CGFloat, mass: CGFloat, hasGravity: Bool, isDynamic: Bool) {
        self.coordinates = coordinates
        self.radius = radius
        self.mass = mass
        self.hasGravity = hasGravity
        self.isDynamic = isDynamic
    }
    
    func update() -> PhysicsBody {
        // If not dynamic, just return itself
        if !self.isDynamic {
            return self
        }

        let newCoordinates = CGPoint(x: coordinates.x, y: coordinates.y + 1)
        return Circle(coordinates: newCoordinates, radius: radius, mass: mass+1, hasGravity: hasGravity, isDynamic: isDynamic)
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
