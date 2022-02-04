//
//  PhysicsEngine.swift
//  pegglegame
//
//  Created by kevin chua on 22/1/22.
//

import CoreGraphics
import Combine

class PhysicsEngine: ObservableObject {
    
    var publisher: AnyPublisher<[GameObject], Never> {
        subject.eraseToAnyPublisher()
    }

    private let subject = PassthroughSubject<[GameObject], Never>()
    
    var gameObjList: [GameObject]
    
    init(gameObjList: [GameObject]) {
        self.gameObjList = gameObjList
    }
    
    /*
     Credit to
     https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-distance-between-two-cgpoints
     for fast and easy distance calculation
     */
    static func CGPointDistanceSquared(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        (fromPoint.x - toPoint.x) * (fromPoint.x - toPoint.x) + (fromPoint.y - toPoint.y) * (fromPoint.y - toPoint.y)
    }

    static func CGPointDistance(fromPoint: CGPoint, toPoint: CGPoint) -> CGFloat {
        sqrt(CGPointDistanceSquared(fromPoint: fromPoint, toPoint: toPoint))
    }
    
//    func setPhysicsBodies(objArr: [GameObject]) {
//        /// Here, I am modifying an array of physics bodies
////        var phyBodyArr: [PhysicsBody] = []
////        for obj in objArr {
////            phyBodyArr.append(obj.physicsBody)
////        }
////        self.bodies = phyBodyArr
//        self.bodies = objArr
//    }
    
    
    func update(deltaTime seconds: CGFloat) -> [GameObject] {
        var res: [GameObject] = []
        for gameobject in gameObjList {
//            gameobject.objectWillChange.send()
            let newPhysicsBody: PhysicsBody = gameobject.physicsBody.update(deltaTime: seconds)
            let newGameObj = GameObject(physicsBody: newPhysicsBody, imageName: gameobject.imageName)
            res.append(newGameObj)
        }
//        self.bodies = res
        gameObjList = res
        return res
    }
    
    func addObj(obj: GameObject) {
        gameObjList.append(obj)
    }

}
