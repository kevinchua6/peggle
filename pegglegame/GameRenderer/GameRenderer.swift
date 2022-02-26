//
//  GameRenderer.swift
//  pegglegame
//
//  Created by kevin chua on 2/2/22.
//

import Combine
import QuartzCore
import SwiftUI

class GameRenderer {
    var publisher: AnyPublisher<[GameObject], Never> {
        objArrSubject.eraseToAnyPublisher()
    }
    var scorePublisher: AnyPublisher<ScoreEngine, Never> {
        scoreSubject.eraseToAnyPublisher()
    }

    private let objArrSubject = PassthroughSubject<[GameObject], Never>()

    private let scoreSubject = PassthroughSubject<ScoreEngine, Never>()

    private let gameEngine: GameEngine
    private var displaylink: CADisplayLink!

    init(objArr: [GameObject], effect: Effects) {
        self.gameEngine = GameEngine(objArr: objArr, effect: effect)
        self.displaylink = CADisplayLink(target: self, selector: #selector(update))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func update() {
        objArrSubject.send(gameEngine.update())

        scoreSubject.send(gameEngine.updateGameState())
    }

    func addObj(obj: GameObject) {
        self.gameEngine.addObj(obj: obj)
    }

    func setBoundaries(bounds: CGRect) {
        gameEngine.setBoundaries(bounds: bounds)
    }

    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        gameEngine.hasObj(lambdaFunc: lambdaFunc)
    }

    func stop() {
        displaylink.invalidate()
    }
}
