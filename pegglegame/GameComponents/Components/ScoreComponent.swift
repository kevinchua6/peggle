//
//  ScoreComponent.swift
//  pegglegame
//
//  Created by kevin chua on 25/2/22.
//

import Foundation

class ScoreComponent: Component {
    var isShown: Bool
    var score: Int
    
    init(score: Int) {
        self.score = score
        self.isShown = false
    }
    
    func hide() {
        self.isShown = false
    }
    
    func show() {
        self.isShown = true
    }
    
    func reset() {
        self.hide()
    }
}
