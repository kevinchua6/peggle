//
//  PersistenceUtils.swift
//  pegglegame
//
//  Created by kevin chua on 27/1/22.
//

import SwiftUI

class PersistenceUtils {
    static let databaseUserDefaultKey = "boardList"

    static func loadBoardList() -> BoardList {
        // Decode data to object
        guard let boardList =
                UserDefaults.standard.value(forKey: PersistenceUtils.databaseUserDefaultKey) as? Data else {
            return BoardList(boards: [:])
        }

        do {
            let decodedBoardList = try JSONDecoder().decode(BoardList.self, from: boardList)

            return decodedBoardList
        } catch {
            print(error)
        }

        return BoardList(boards: [:])
    }

    static func encodeGameObjArrToBoard(gameObjArr: [GameObject], as name: String) -> Board {
        var board = Board(name: name, objArr: [])

        // Convert all objects into encodablePegs
        for obj in gameObjArr {
            var objType: String
            switch obj {
            case is BluePeg:
                objType = GameObject.Types.bluePeg.rawValue
            case is OrangePeg:
                objType = GameObject.Types.orangePeg.rawValue
            default:
                continue
            }

            board.objArr.append(
                EncodableObject(
                    xcoord: obj.physicsBody.coordinates.x,
                    ycoord: obj.physicsBody.coordinates.y, type: objType
                )
            )
        }

        return board
    }

    static func decodeBoardToGameObjArr(board: Board) -> [GameObject] {
        var gameObjBoard: [GameObject] = []
        for obj in board.objArr {
            switch obj.type {
            case GameObject.Types.bluePeg.rawValue:
                gameObjBoard.append(
                    BluePeg(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        name: GameObject.Types.bluePeg.rawValue)
                )
            case GameObject.Types.orangePeg.rawValue:
                gameObjBoard.append(
                    OrangePeg(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        name: GameObject.Types.orangePeg.rawValue)
                )
            default:
                continue
            }
        }
        return gameObjBoard
    }

}
