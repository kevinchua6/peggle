//
//  StartGameViewModel.swift
//  pegglegame
//
//  Created by kevin chua on 2/2/22.
//

import Foundation
import CoreGraphics

// TODO: make model more accurate to the angle and improve algo
class StartGameViewModel: ObservableObject {
    
    @Published var objArr: [GameObject] = []
    
    init(objArr: [GameObject]) {
        self.objArr = objArr
    }
    
    func getAngle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
        if source == dest {
            return 0.0
        }
        let hey = atan((source.y - dest.y) / (-source.x + dest.x))
        
        if hey >= 0 {
            return 3.142/2 - hey
        } else {
            return  -abs(hey + 3.142/2)
        }

    }
}
