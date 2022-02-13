// swiftlint:disable:this file_name
// Disabled here as I cannot find a workaround for this.
// I want all my extensions for CoreGraphics to be in a single file

import CoreGraphics

extension CGPoint {
    // Euclidean vector
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
        CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }

    // Shifting a point forward by rhs
    static func + (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    // Shifting a point forward by rhs
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    // Shifting a point back by rhs
    static func - (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        CGPoint(x: lhs.x - rhs, y: lhs.y - rhs)
    }

    // Shifting a point back by a vector
    static func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
}

extension CGVector {

    // Shifting a point forward by another vector
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    // Return a vector sum of a negative of another vector
    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    // Check if a length of a vector is less than a value
    static func <= (lhs: CGVector, rhs: CGFloat) -> Bool {
        sqrt(lhs.dx * lhs.dx + lhs.dy * lhs.dy) <= rhs
    }

    static func += (lhs: inout CGPoint, rhs: CGVector) {
        // This is done to avoid swiftlint shorthand_operator violation
        let left = lhs
        lhs = left + rhs
    }

    // Return a vector divided by the distance
    static func / (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
    }

    // Returns the float when two vectors are multipled by their axis
    static func * (lhs: CGVector, rhs: CGVector) -> CGFloat {
        lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }

    // Multiplies a vector by the magnitude to give a vector
    static func * (lhs: CGVector, rhs: CGFloat) -> CGVector {
        CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }

    // Multiplies a vector by the magnitude to give a float
    static func * (lhs: CGVector, rhs: CGFloat) -> CGFloat {
        lhs.dx * rhs + lhs.dy * rhs
    }
}
