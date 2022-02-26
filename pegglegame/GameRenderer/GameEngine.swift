//
//  GameEngine.swift
//  pegglegame
//
//  Created by kevin chua on 11/2/22.
//

import Combine
import Foundation
import QuartzCore
import SwiftUI

// A game engine stores the reference to all the moving and colliding things on the screen
class GameEngine {
    private let physicsEngine: PhysicsEngine
    private var bounds: CGRect?

    private let framesPerSecond: CGFloat = 60

    private var noPegHit = 0
    private var noOrangePegHit = 0
    private var noOfBallsRemaining = 10

    private let ADDITIONAL_WALL_LENGTH = 50.0
    private let RATE_OF_FADING = 0.1

    private let MIN_VELOCITY = 150.0
    private let REMOVE_BALL_INTERVAL = 1.7

    private let HOOKS_CONSTANT = 200.0
    private let SPRING_CONSTANT = 1.0
    private let DAMPING_CONSTANT = 10.0

    private weak var timer: Timer?

    var scoreEngine: ScoreEngine

    var objArr: [GameObject]

    init(objArr: [GameObject]) {
        self.objArr = objArr
        self.physicsEngine = PhysicsEngine()
        self.scoreEngine = ScoreEngine(
            initialNoOrangePeg: objArr.filter({ $0.hasComponent(of: OrangePegComponent.self) }).count,
            initialNoPeg: objArr.filter({ $0.hasComponent(of: PegComponent.self) }).count,
            gameStatus: .playing
        )
    }

    func update() -> [GameObject] {
        if let myBounds = self.bounds {
            // Remove pegs only a certain amount away from the bounds
            let outerBounds = CGRect(
                x: myBounds.minX - ADDITIONAL_WALL_LENGTH,
                y: myBounds.minY - ADDITIONAL_WALL_LENGTH,
                width: myBounds.width + 2 * ADDITIONAL_WALL_LENGTH,
                height: myBounds.height + 2 * ADDITIONAL_WALL_LENGTH
            )

            activateSpookyBall(bounds: outerBounds)
            removeObjOutsideBoundaries(bounds: outerBounds)
            removeLightedUpPegsConditionally(bounds: outerBounds)
        }

        simulatePhysics()

        return self.objArr
    }

    func updateGameState() -> ScoreEngine {

        if scoreEngine.noPegHit == 200 {
            scoreEngine.gameStatus = .won
        }

        return scoreEngine
    }

    func getNoOfBallsRemaining() -> Int {
        noOfBallsRemaining
    }

    func increaseHitCount(gameObj: GameObject) {
        if gameObj.hasComponent(of: OrangePegComponent.self) {
            scoreEngine.noOrangePegHit += 1
        }
        if gameObj.hasComponent(of: PegComponent.self) {
            scoreEngine.noPegHit += 1
        }
    }

    private func simulatePhysics() {
        // Update coordinates
        for gameObj in objArr.filter({ $0.physicsBody.isDynamic }) {
            gameObj.physicsBody =
                self.physicsEngine.updateCoordinates(
                    physicsBody: gameObj.physicsBody,
                    deltaTime: CGFloat(1 / framesPerSecond))
        }

        // Update dynamic bodies' velocities upon collision
        for gameObj in objArr {
            var isHit: Bool

            // Don't make bucket collide with other things
            if let bucketComponent = gameObj.getComponent(of: BucketComponent.self) {
                gameObj.physicsBody = bucketComponent.updateVelocity(
                    gameObj: gameObj, objArr: objArr, physicsEngine: physicsEngine
                )

                objArr = bucketComponent.removeBall(bucket: gameObj, objArr: objArr)

            } else if let triangleBlock = gameObj.getComponent(of: OscillatingComponent.self) {
                triangleBlock.updateVelocityOnHit(gameObj: gameObj, objArr: objArr, physicsEngine: physicsEngine)
            } else {
                (gameObj.physicsBody, isHit) =
                    self.physicsEngine.updateVelocities(
                        physicsBody: gameObj.physicsBody,
                        physicsBodyArr: objArr.map { $0.physicsBody },
                        deltaTime: CGFloat(1 / framesPerSecond)
                    )

                // Set all hittable components to hit
                if isHit && !gameObj.isHit {
                    gameObj.getComponent(of: ActivateOnHitComponent.self)?.setHit(to: true)
                    gameObj.getComponent(of: ScoreComponent.self)?.show()
                    increaseHitCount(gameObj: gameObj)
                }

                // activate spooky ball
                if gameObj.hasComponent(of: SpookyPegComponent.self) && isHit {
                    for cannonBall in objArr.filter({
                        !($0.getComponent(of: SpookyBallComponent.self)?.shouldSpookyBallActivate ?? false)
                    }) {
                        cannonBall.getComponent(of: SpookyBallComponent.self)?.activateSpookyBall()
                    }
                }

                // activate kaboom
                if let kaboomPeg = gameObj.getComponent(of: KaboomPegComponent.self) {
                    if gameObj.isHit && !gameObj.isActivated {
                        gameObj.activate()
                        objArr = kaboomPeg.explodeSurroundingPegs(kaboomPeg: gameObj, objArr: objArr)
                    }
                }
            }
        }

        // Update the coordinates to prevent overlapping
        for gameObj in objArr.filter({
            $0.physicsBody.isDynamic
            && !$0.hasComponent(of: OscillatingComponent.self)
        }) {
            gameObj.physicsBody =
                self.physicsEngine.updatePreventOverlapping(
                    physicsBody: gameObj.physicsBody,
                    physicsBodyArr: objArr.map { $0.physicsBody },
                    deltaTime: CGFloat(1 / framesPerSecond)
                )
        }
    }

    func addObj(obj: GameObject) {
        objArr.append(obj)
    }

    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        objArr.contains(where: lambdaFunc)
    }

    func setBoundaries(bounds: CGRect) {
        self.bounds = bounds
    }

    private func removeLightedUpPegsConditionally(bounds: CGRect) {
        let ballArr = objArr.filter({
            $0.hasComponent(of: CannonBallComponent.self)
        })

        guard !ballArr.isEmpty else {
            // Remove lighted up pegs when no balls exist
            removeLightedUpPegs()
            timer?.invalidate()
            return
        }

        for ball in ballArr {
            if ball.physicsBody.velocity <= MIN_VELOCITY {
                if timer == nil || !(timer?.isValid ?? true) {
                    timer = Timer.scheduledTimer(
                        withTimeInterval: REMOVE_BALL_INTERVAL, repeats: false, block: { [self] _ in
                            self.removeLightedUpPegs()
                        })
                }
            } else {
                timer?.invalidate()
            }
        }
    }

    private func removeLightedUpPegs() {
        objArr = objArr.filter {
            !($0.getComponent(of: ActivateOnHitComponent.self)?.isHit ?? false)
        }
    }

    private func removeObjOutsideBoundaries(bounds: CGRect) {
        let ballArr = objArr.filter({
            $0.hasComponent(of: CannonBallComponent.self) && !bounds.contains($0.physicsBody.boundingBox)
        })

        if !ballArr.isEmpty {
            scoreEngine.noOfBallsRemaining -= 1
        } else {
            checkWinConditions()
        }

        objArr = objArr.filter {
            bounds.contains($0.physicsBody.boundingBox)
                || !$0.hasComponent(of: CannonBallComponent.self)
        }

    }

    private func activateSpookyBall(bounds: CGRect) {
        for cannonBall in objArr.filter({ $0.hasComponent(of: CannonBallComponent.self) }) {
            if (cannonBall.getComponent(of: SpookyBallComponent.self)?.shouldSpookyBallActivate ?? false)
                && !bounds.contains(cannonBall.boundingBox) {
                removeLightedUpPegs()
                cannonBall.coordinates = CGPoint(x: cannonBall.coordinates.x, y: 10)
                cannonBall.getComponent(of: SpookyBallComponent.self)?.deactivateSpookyBall()
            }
        }
    }

    private func checkWinConditions() {
        if scoreEngine.noOfBallsRemaining <= 0 {
            scoreEngine.gameStatus = .lost
        }

        let noOfOrangePegsOnScreen = objArr.filter({ $0.hasComponent(of: OrangePegComponent.self) }).count

        if noOfOrangePegsOnScreen <= 0 {
            scoreEngine.gameStatus = .won
        }
    }
}
