//
//  ScoreEngine.swift
//  pegglegame
//
//  Created by kevin chua on 26/2/22.
//

import Foundation

class ScoreEngine {
    var noPegHit = 0
    var noOrangePegHit = 0
    var noOfBallsRemaining = 10

    let initialNoOrangePeg: Int
    let initialNoPeg: Int

    var gameStatus: Status

    init(initialNoOrangePeg: Int, initialNoPeg: Int, gameStatus: Status) {
        self.initialNoOrangePeg = initialNoOrangePeg
        self.initialNoPeg = initialNoPeg
        self.gameStatus = gameStatus
    }

    enum Status {
        case won, lost, playing
    }

    var score: Int {
        noPegHit * 100 + noOrangePegHit * 50
    }
}
