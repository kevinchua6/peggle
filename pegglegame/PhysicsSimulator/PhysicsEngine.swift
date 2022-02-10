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
//                    print(dynamicObject.physicsBody.forces)
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
