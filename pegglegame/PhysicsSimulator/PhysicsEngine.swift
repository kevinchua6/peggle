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
    
    static func getVertAcuteAngle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
        atan((dest.x - source.x)/(source.y - dest.y))
    }
    
    static func getHorizAcuteAngle(from source: CGPoint, to dest: CGPoint) -> CGFloat {
        atan((dest.y - source.y)/(source.x - dest.x))
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
            // Update bodies to next coordinates
            let newPhysicsBody: PhysicsBody = gameobject.physicsBody.update(deltaTime: seconds)
            
            let newGameObj = GameObject(physicsBody: newPhysicsBody, imageName: gameobject.imageName)
            
            res.append(newGameObj)
        }
        
        // Update the forces array for each dynamic object
        for dynamicObject in res.filter({ $0.physicsBody.isDynamic }) {
            for gameObject in res {
                if dynamicObject === gameObject {
                    continue
                }
                
                // If intersecting,
                if dynamicObject.physicsBody.isIntersecting(with: gameObject) {
                    dynamicObject.physicsBody.handleCollision(with: gameObject.physicsBody)
                }
            }
        }
        
        
        gameObjList = res
        return res
    }
    
    func addObj(obj: GameObject) {
        gameObjList.append(obj)
    }

}
