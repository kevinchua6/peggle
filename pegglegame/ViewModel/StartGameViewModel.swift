//
//  StartGameViewModel.swift
//  pegglegame
//
//  Created by kevin chua on 2/2/22.
//

import CoreGraphics
import Combine

class StartGameViewModel: ObservableObject {

    private var objArrCancellable: AnyCancellable?
    private var scoreEngineCancellable: AnyCancellable?

    @Published var objArr: [GameObject] = []

    var gameRenderer: GameRenderer

    @Published var scoreEngine: ScoreEngine

    let MAX_ANGLE = Double.pi / 2
    let INITIAL_BALL_SPEED = 1_000.0
    let WALL_THICKNESS = 2.0
    
    var effect: Effects

    struct AlertBox {
        var visible: Bool
        var title: String
        var message: String
    }

    @Published var alert = AlertBox(visible: false, title: "", message: "")

    init(objArr: [GameObject], effect: Effects) {
        // Whenever start is pressed, reset all properties
        for gameObj in objArr {
            gameObj.reset()
        }
        
        self.effect = effect
        
        self.scoreEngine = ScoreEngine(initialNoOrangePeg: 0, initialNoPeg: 0, gameStatus: .playing)
        
        
        gameRenderer = GameRenderer(objArr: objArr, effect: effect)

        objArrCancellable = gameRenderer.publisher.sink { [weak self] objArr in
            self?.objArr = objArr
        }

        scoreEngineCancellable = gameRenderer.scorePublisher.sink { [weak self] scoreEngine in
            self?.scoreEngine = scoreEngine

            switch scoreEngine.gameStatus {
            case .won:
                self?.alert.title = "You win!"
                self?.alert.visible = true
                self?.gameRenderer.stop()
            case .lost:
                self?.alert.title = "You lost!"
                self?.alert.visible = true
                self?.gameRenderer.stop()
            case .playing:
                self?.alert.visible = false
            }

            self?.alert.message = "Score: \(scoreEngine.score)"
        }
    }

    func setBoundaries(bounds: CGRect) {
        createWalls(bounds: bounds)
        createBucket(bounds: bounds)
        gameRenderer.setBoundaries(bounds: bounds)
    }

    func createBucket(bounds: CGRect) {
        gameRenderer.addObj(
            obj: Bucket(coordinates: CGPoint(x: 100.0, y: bounds.maxY * 18.5 / 20.0), radius: 30.0)
        )
    }

    func createWalls(bounds: CGRect) {
        gameRenderer.addObj(
            obj: Wall(
                coordinates: CGPoint(x: -WALL_THICKNESS, y: 0),
                width: WALL_THICKNESS,
                height: bounds.height * 1.5
                     )
        )
        gameRenderer.addObj(
            obj: Wall(coordinates: CGPoint(x: bounds.maxX + WALL_THICKNESS, y: 0),
                      width: WALL_THICKNESS,
                      height: bounds.height * 1.5
                     )
        )
        gameRenderer.addObj(obj: Wall(coordinates: CGPoint(x: 0,
                                                           y: -WALL_THICKNESS
                                                          ),
                                      width: bounds.width,
                                      height: WALL_THICKNESS
                                     )
        )
    }

    func getCannonAngle(cannonLoc: CGPoint, gestureLoc: CGPoint) -> CGFloat {
        // only detect the bottom two quadrants
        if gestureLoc.y < cannonLoc.y {
            if gestureLoc.x > cannonLoc.x {
                return -MAX_ANGLE
            } else {
                return MAX_ANGLE
            }
        }

        // keep cannon between two values
        let cannonAngle = max(
            -MAX_ANGLE, min(
                MAX_ANGLE,
                PhysicsEngineUtils.getVertAcuteAngle(from: cannonLoc, to: gestureLoc)
            )
        )

        return cannonAngle
    }

    func shootBall(from: CGPoint, to: CGPoint) {
        if gameRenderer.hasObj(lambdaFunc: { $0.imageName == Ball.imageName }) {
            return
        }

        let ball = Ball(coordinates: from)
        
        // if windy, make the ball have a windy property
        if effect == .windy {
            ball.setComponent(of: WindyComponent())
        }

        let angle = getCannonAngle(cannonLoc: from, gestureLoc: to)
        let unitVector = CGVector(dx: -sin(angle), dy: cos(angle))

        gameRenderer.addObj(obj: ball)
        ball.physicsBody.velocity = unitVector * INITIAL_BALL_SPEED
    }

    func getNoOfPegHit() -> Int {
        scoreEngine.noPegHit
    }

    func noOrngePegHit() -> Int {
        scoreEngine.noOrangePegHit
    }

    func initialNoOrngePeg() -> Int {
        scoreEngine.initialNoOrangePeg
    }

    func getInitialNoOfPegHit() -> Int {
        scoreEngine.initialNoPeg
    }

    deinit {
        gameRenderer.stop()
    }
}
