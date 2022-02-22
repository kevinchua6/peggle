//
//  pegglegameTests.swift
//  pegglegameTests
//
//  Created by kevin chua on 13/2/22.
//

import XCTest
@testable import pegglegame

class pegglegameTests: XCTestCase {

    private var bluePeg: BluePeg!
    private var bluePeg2: BluePeg!
    private var orangePeg: OrangePeg!
    private var orangePeg2: OrangePeg!

    override func setUpWithError() throws {
        try super.setUpWithError()
        bluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), name: "")
        bluePeg2 = BluePeg(coordinates: CGPoint(x: 2.0, y: 2.0), name: "")
        orangePeg = OrangePeg(coordinates: CGPoint(x: 1.0, y: 1.0), name: "")
        orangePeg2 = OrangePeg(coordinates: CGPoint(x: 2.0, y: 2.0), name: "")
    }

    func testPeg_overlapping_collide() {
        // Collides with itselff
        XCTAssertTrue(bluePeg.physicsBody.isIntersecting(with: bluePeg.physicsBody))
        XCTAssertTrue(bluePeg2.physicsBody.isIntersecting(with: bluePeg2.physicsBody))
        XCTAssertTrue(orangePeg.physicsBody.isIntersecting(with: orangePeg.physicsBody))
        XCTAssertTrue(orangePeg2.physicsBody.isIntersecting(with: orangePeg2.physicsBody))

        // Collide with same type
        XCTAssertTrue(bluePeg.physicsBody.isIntersecting(with: bluePeg2.physicsBody))
        XCTAssertTrue(bluePeg2.physicsBody.isIntersecting(with: bluePeg.physicsBody))
        XCTAssertTrue(orangePeg.physicsBody.isIntersecting(with: orangePeg2.physicsBody))
        XCTAssertTrue(orangePeg2.physicsBody.isIntersecting(with: orangePeg.physicsBody))

        // Collide with different type
        XCTAssertTrue(bluePeg.physicsBody.isIntersecting(with: orangePeg2.physicsBody))
        XCTAssertTrue(bluePeg2.physicsBody.isIntersecting(with: orangePeg.physicsBody))
        XCTAssertTrue(orangePeg.physicsBody.isIntersecting(with: bluePeg2.physicsBody))
        XCTAssertTrue(orangePeg2.physicsBody.isIntersecting(with: bluePeg.physicsBody))

        var radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 1.0, name: "")
        var radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 2.0, y: 1.0), radius: 1.0, name: "")
        XCTAssertTrue(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2.physicsBody))

        radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 100, name: "")
        radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 100.0, y: 100.0), radius: 100, name: "")
        XCTAssertTrue(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2.physicsBody))
    }

    func testPeg_notOverlapping_dontCollide() {
        var radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 1.0, name: "")
        var radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 3.0, y: 1.0), radius: 1.0, name: "")
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2.physicsBody))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg.physicsBody))

        var radiusOneOrangePeg = OrangePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 1.0, name: "")
        var radiusOneOrangePeg2 = OrangePeg(coordinates: CGPoint(x: 3.0, y: 1.0), radius: 1.0, name: "")
        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2.physicsBody))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg.physicsBody))

        // Different pegs
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2.physicsBody))
        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2.physicsBody))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg.physicsBody))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg.physicsBody))

        // diagonal dont collide: sqrt 2 = 1.414 so test 0.7 * 2
        radiusOneBluePeg = BluePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 0.7, name: "")
        radiusOneBluePeg2 = BluePeg(coordinates: CGPoint(x: 2.0, y: 2.0), radius: 0.7, name: "")
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2.physicsBody))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg.physicsBody))

        radiusOneOrangePeg = OrangePeg(coordinates: CGPoint(x: 1.0, y: 1.0), radius: 0.7, name: "")
        radiusOneOrangePeg2 = OrangePeg(coordinates: CGPoint(x: 2.0, y: 2.0), radius: 0.7, name: "")
        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2.physicsBody))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg.physicsBody))

        XCTAssertFalse(radiusOneOrangePeg.physicsBody.isIntersecting(with: radiusOneBluePeg2.physicsBody))
        XCTAssertFalse(radiusOneBluePeg2.physicsBody.isIntersecting(with: radiusOneOrangePeg.physicsBody))
        XCTAssertFalse(radiusOneBluePeg.physicsBody.isIntersecting(with: radiusOneOrangePeg2.physicsBody))
        XCTAssertFalse(radiusOneOrangePeg2.physicsBody.isIntersecting(with: radiusOneBluePeg.physicsBody))
    }

}
