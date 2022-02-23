//
//  LevelDesignerViewlModel.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import Foundation
import CoreGraphics
import Combine

class LevelDesignerViewModel: ObservableObject {
    enum PegSelectionColor: String {
        case blue, orange
    }

    enum SelectionMode: Equatable {
        case add(PegSelectionColor), delete
    }

    struct AlertBox {
        var visible: Bool
        var title: String
        var message: String
    }
    
    @Published var placeholderObj =
        PlaceholderObj(
            imageName: BluePeg.imageName,
            object: BluePeg(coordinates: CGPoint(x: 0, y: 0),
                            name: "placeholder"),
            isVisible: false
        )
    
    @Published var selectedObj: GameObject?

    @Published var alert = AlertBox(visible: false, title: "", message: "")

    @Published var selectionMode: SelectionMode = .add(.blue)
    @Published var selectionObject = BluePeg.selectionObject

    @Published var placeholderLocation = CGPoint(x: 50, y: 50)
    @Published var placeholderObjImg: String = ""

    @Published var objArr: [GameObject] = []
    @Published var boardList = PersistenceUtils.loadBoardList()
    
    func selectObj(obj: GameObject) {
        self.selectedObj = obj
    }

    func deleteObj(obj: GameObject) {
        objArr = objArr.filter { $0 !== obj }
        selectedObj = nil
    }
    
    
    func moveObj(obj: GameObject, to endCoord: CGPoint) {
        obj.coordinates = endCoord
    }

    func placeObj(at coordinates: CGPoint) {
        guard case let .add(color) = selectionMode else {
            return
        }

        // Convert to physics body array to check for intersection
        let physicsBodyArr = objArr.map { $0.physicsBody }

        switch color {
        case PegSelectionColor.blue:
            let bluePeg = BluePeg(coordinates: coordinates, name: GameObject.Types.bluePeg.rawValue)
            if bluePeg.physicsBody.isIntersecting(with: physicsBodyArr) {
                return
            }

            objArr.append(bluePeg)
            self.selectedObj = bluePeg
        case PegSelectionColor.orange:
            let orangePeg = OrangePeg(coordinates: coordinates, name: GameObject.Types.orangePeg.rawValue)
            if orangePeg.physicsBody.isIntersecting(with: physicsBodyArr) {
                return
            }

            objArr.append(orangePeg)
            self.selectedObj = orangePeg
        }
    }

    func dragObj(obj: GameObject, from coordinates: CGPoint, by translation: CGSize) {
        obj.physicsBody.coordinates.x = coordinates.x + translation.width
        obj.physicsBody.coordinates.y = coordinates.y + translation.height
    }

    // Checks whether when you click on the board, the thing is valid
    func isValidPlacement(physicsBody: PhysicsBody, bounds: CGRect) -> Bool {
        let isWithinBounds = bounds.contains(physicsBody.boundingBox)
        let physicsBodyArr = objArr.map { $0.physicsBody }

        let isNotIntersecting = !physicsBody.isIntersecting(with: physicsBodyArr)
        return isNotIntersecting && isWithinBounds
    }

    // When dragging, you ignore the object that you are dragging from
    func isValidDrag(object: GameObject, originalObj: GameObject, bounds: CGRect) -> Bool {
        let isWithinBounds = bounds.contains(object.physicsBody.boundingBox)

        let objArrWithoutCurr = objArr.filter { $0 !== originalObj }

        let physicsBodyArr = objArrWithoutCurr.map { $0.physicsBody }

        // Placeholder must not intersect with all other objects
        // But placeholder can intersect with object
        let isNotIntersectingOtherObjects = !object.physicsBody.isIntersecting(with: physicsBodyArr)
        return isNotIntersectingOtherObjects && isWithinBounds
    }

    func dragObjPlaceholder(object: PlaceholderObj, translation: CGSize) -> CGPoint {
        var newLocation = object.object.physicsBody.coordinates

        newLocation.x += translation.width
        newLocation.y += translation.height

        return newLocation
    }
    
    func updateBoard() {
        objectWillChange.send()
    }
    
    func updateWidth(gameObject: GameObject, width: CGFloat, bounds: CGRect) {
        guard width >= GameBoardView.DEFAULT_OBJ_LENGTH else {
            return
        }
        
        var newPhysicsBody = gameObject.physicsBody
        newPhysicsBody.setWidth(width: width)
        
        if newPhysicsBody.isIntersecting(with: objArr.filter{$0 !== gameObject}.map{$0.physicsBody}) || !bounds.contains(newPhysicsBody.boundingBox) {
            return
        }

        var newObjArr = objArr.filter{ $0 !== gameObject }
        
        gameObject.physicsBody = newPhysicsBody

        
        newObjArr.append(gameObject)
        objArr = newObjArr
    }

    // Persistence functions
    func saveBoard(gameObjArr: [GameObject], as name: String) throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            alert = AlertBox(visible: true, title: "Empty Level Name", message: "Please input a title for your level")
            return
        }

        // Encode it as a Board with EncodableObjects
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let board = PersistenceUtils.encodeGameObjArrToBoard(gameObjArr: gameObjArr, as: trimmedName)

        if let boardList = UserDefaults.standard.value(forKey: PersistenceUtils.databaseUserDefaultKey) as? Data {
            // If boardlist exists, add to it
            var decodedBoardlist = try JSONDecoder().decode(BoardList.self, from: boardList)

            decodedBoardlist.boards[trimmedName] = board

            let data = try encoder.encode(decodedBoardlist)
            UserDefaults.standard.set(data, forKey: PersistenceUtils.databaseUserDefaultKey)
            alert = AlertBox(visible: true, title: "Saved", message: "Level \(trimmedName) saved!")
        } else {
            // If no existing boardList, create one
            let newBoardList = BoardList(boards: [trimmedName: board])

            let data = try encoder.encode(newBoardList)
            UserDefaults.standard.set(data, forKey: PersistenceUtils.databaseUserDefaultKey)
        }
    }
}
