//
//  physicsTests.swift
//  pegglegameTests
//
//  Created by kevin chua on 28/1/22.
//

import XCTest
@testable import pegglegame

class PhysicsTests: XCTestCase {

    private var bluePeg: BluePeg!
    private var bluePeg2: BluePeg!
    private var orangePeg: OrangePeg!
    private var orangePeg2: OrangePeg!

    override func setUpWithError() throws {
        try super.setUpWithError()
        bluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0))
        bluePeg2 = BluePeg(coordinates: CGPoint(x: 2.0, y: 2.0))
        orangePeg = OrangePeg(coordinates: CGPoint(x: 1.0, y: 1.0))
        orangePeg2 = OrangePeg(coordinates: CGPoint(x: 2.0, y: 2.0))
    }

    func testPeg_overlapping_collide() {
        // Collides with itself
        XCTAssertTrue(bluePeg.physicsBody.isIntersecting(with: bluePeg))
        XCTAssertTrue(bluePeg2.physicsBody.isIntersecting(with: bluePeg2))
        XCTAssertTrue(orangePeg.physicsBody.isIntersecting(with: orangePeg))
        XCTAssertTrue(orangePeg2.physicsBody.isIntersecting(with: orangePeg2))

        // Collide with same type
        XCTAssertTrue(bluePeg.physicsBody.isIntersecting(with: bluePeg2))
        XCTAssertTrue(bluePeg2.physicsBody.isIntersecting(with: bluePeg))
        XCTAssertTrue(orangePeg.physicsBody.isIntersecting(with: orangePeg2))
        XCTAssertTrue(orangePeg2.physicsBody.isIntersecting(with: orangePeg))

        // Collide with different type
        XCTAssertTrue(bluePeg.physicsBody.isIntersecting(with: orangePeg2))
        XCTAssertTrue(bluePeg2.physicsBody.isIntersecting(with: orangePeg))
        XCTAssertTrue(orangePeg.physicsBody.isIntersecting(with: bluePeg2))
        XCTAssertTrue(orangePeg2.physicsBody.isIntersecting(with: bluePeg))

        var radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 1.0)
        var radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 2.0, y: 1.0), radius: 1.0)
        XCTAssertTrue(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2))

        radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 100)
        radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 100.0, y: 100.0), radius: 100)
        XCTAssertTrue(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2))
    }

    func testPeg_notOverlapping_dontCollide() {
        var radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 1.0)
        var radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 3.0, y: 1.0), radius: 1.0)
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg))

        var radiusOneOrangePeg = OrangePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 1.0)
        var radiusOneOrangePeg2 = OrangePeg(coordinates: CGPoint(x: 3.0, y: 1.0), radius: 1.0)
        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg))

        // Different pegs
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2))
        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg))

        // diagonal dont collide: sqrt 2 = 1.414 so take
        radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 0.7)
        radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 2.0, y: 2.0), radius: 0.7)
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg))

        radiusOneOrangePeg = OrangePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 0.7)
        radiusOneOrangePeg2 = OrangePeg(coordinates: CGPoint(x: 2.0, y: 2.0), radius: 0.7)
        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg))

        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg))
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg))
    }
}
