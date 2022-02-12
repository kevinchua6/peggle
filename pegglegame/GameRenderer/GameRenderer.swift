//
//  GameRenderer.swift
//  pegglegame
//
//  Created by kevin chua on 2/2/22.
//

import Combine
import Foundation
import QuartzCore
import SwiftUI

class GameRenderer {
    var publisher: AnyPublisher<[GameObject], Never> {
        subject.eraseToAnyPublisher()
    }

    private let subject = PassthroughSubject<[GameObject], Never>()

    private let gameEngine: GameEngine
    private var displaylink: CADisplayLink!

    init(gameObjList: [GameObject]) {
        self.gameEngine = GameEngine(gameObjList: gameObjList)
        self.displaylink = CADisplayLink(target: self, selector: #selector(update))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func update() {
        subject.send(gameEngine.update())
    }
 
    func addObj(obj: GameObject) {
        self.gameEngine.addObj(obj: obj)
    }

    func stop() {
        displaylink.invalidate()
        displaylink.remove(from: .current, forMode: .default)
        displaylink = nil
    }
    
    func setBoundaries(bounds: CGRect) {
        gameEngine.setBoundaries(bounds: bounds)
    }
    
    func hasObj(lambdaFunc: (GameObject) -> Bool) -> Bool {
        gameEngine.hasObj(lambdaFunc: lambdaFunc)
    }
}
