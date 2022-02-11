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

    private let physicsEngine: PhysicsEngine
    private var displaylink: CADisplayLink!

    let framesPerSecond: CGFloat = 60

    init(gameObjList: [GameObject]) {
        self.physicsEngine = PhysicsEngine(gameObjList: gameObjList)
        self.displaylink = CADisplayLink(target: self, selector: #selector(update))
        displaylink.add(to: .current, forMode: .default)
    }

    @objc func update() {
        subject.send(self.physicsEngine.update(deltaTime: CGFloat(1 / framesPerSecond)))
    }

    func addObj(obj: GameObject) {
        self.physicsEngine.addObj(obj: obj)
    }

    func stop() {
        displaylink.invalidate()
        displaylink.remove(from: .current, forMode: .default)
        displaylink = nil
    }
}
