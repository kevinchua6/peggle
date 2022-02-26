//
//  ScoreEngine.swift
//  pegglegame
//
//  Created by kevin chua on 26/2/22.
//

import Foundation

struct ScoreEngine {
    var noPegHit = 0
    var noOrangePegHit = 0
    var noOfBallsRemaining = 10

    let initialNoOrangePeg: Int
    let initialNoPeg: Int

    var gameStatus: Status

    enum Status {
        case won, lost, playing
    }

    var score: Int {
        noPegHit * 100 + noOrangePegHit * 50
    }
}
