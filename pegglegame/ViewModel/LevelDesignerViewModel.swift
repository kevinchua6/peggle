//
//  LevelDesignerViewlModel.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import Foundation
import CoreGraphics

class LevelDesignerViewModel: ObservableObject {
    enum SelectionMode: Equatable {
        case add(Peg.Color), delete
    }

    struct AlertBox {
        var visible: Bool
        var title: String
        var message: String
    }

    @Published var alert = AlertBox(visible: false, title: "", message: "")

    @Published var selectionMode: SelectionMode = .add(.blue)
    @Published var selectionObject = BluePeg.selectionObject

    @Published var placeholderLocation = CGPoint(x: 50, y: 50)
    @Published var placeholderObjImg: String = ""

    @Published var objArr: [GameObject] = []
    @Published var boardList = PersistenceUtils.loadBoardList()

    func deleteObj(obj: GameObject) {
        objArr = objArr.filter { $0 !== obj }
    }

    func placeObj(at coordinates: CGPoint) {
        guard case let .add(color) = selectionMode else {
            return
        }

        switch color {
        case Peg.Color.blue:
            let bluePeg = BluePeg(coordinates: coordinates)
            if bluePeg.physicsBody.isIntersecting(with: objArr) {
                return
            }

            objArr.append(bluePeg)
        case Peg.Color.orange:
            let orangePeg = OrangePeg(coordinates: coordinates)
            if orangePeg.physicsBody.isIntersecting(with: objArr) {
                return
            }

            objArr.append(orangePeg)
        }
    }

    func dragObj(obj: GameObject, from coordinates: CGPoint, by translation: CGSize) {
        obj.physicsBody.coordinates.x = coordinates.x + translation.width
        obj.physicsBody.coordinates.y = coordinates.y + translation.height
    }

    // Checks whether when you click on the board, the thing is valid
    func isValidPlacement(object: GameObject, bounds: CGRect) -> Bool {
        let isWithinBounds = bounds.contains(object.physicsBody.boundingBox)
        let isNotIntersecting = !object.physicsBody.isIntersecting(with: objArr)
        return isNotIntersecting && isWithinBounds
    }

    // When dragging, you ignore the object that you are dragging from
    func isValidDrag(object: GameObject, originalObj: GameObject, bounds: CGRect) -> Bool {
        let isWithinBounds = bounds.contains(object.physicsBody.boundingBox)

        let objArrWithoutCurr = objArr.filter { $0 !== originalObj }
        // Placeholder must not intersect with all other objects
        // But placeholder can intersect with object
        let isNotIntersectingOtherObjects = !object.physicsBody.isIntersecting(with: objArrWithoutCurr)
        return isNotIntersectingOtherObjects && isWithinBounds
    }

    func dragObjPlaceholder(object: PlaceholderObj, translation: CGSize) -> CGPoint {
        var newLocation = object.object.physicsBody.coordinates

        newLocation.x += translation.width
        newLocation.y += translation.height

        return newLocation
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
            print(String(data: data, encoding: .utf8)!)
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
