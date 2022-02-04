//
//  StartGameViewModel.swift
//  pegglegame
//
//  Created by kevin chua on 2/2/22.
//

import Foundation
import CoreGraphics
import Combine

class StartGameViewModel: ObservableObject {
    
    //
    private var cancellable: AnyCancellable?
    
    @Published var objArr: [GameObject] = []
    
    var gameRenderer: GameRenderer
    
    let MAX_ANGLE = Double.pi / 2
    
    init(objArr: [GameObject]) {
//        let currGameObjList = GameObjectList(objArr: objArr)
        
        gameRenderer = GameRenderer(gameObjList: objArr)
        cancellable = gameRenderer.publisher.sink { objArr in
            self.objArr = objArr
        }
    }
    
    private func getAngle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
        atan((dest.x - source.x)/(source.y - dest.y))
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
        let cannonAngle = max(-MAX_ANGLE, min(MAX_ANGLE, getAngle(from: cannonLoc, to: gestureLoc)))
        
        return cannonAngle
    }
    
    func placeObj(at coordinates: CGPoint) {
        let bluePeg = Ball(coordinates: coordinates)

//        objArr.append(bluePeg)
        gameRenderer.addObj(obj: bluePeg)
    }
}
