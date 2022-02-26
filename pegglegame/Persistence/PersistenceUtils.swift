//
//  PersistenceUtils.swift
//  pegglegame
//
//  Created by kevin chua on 27/1/22.
//

import SwiftUI

class PersistenceUtils {
    static let databaseUserDefaultKey = "boardList"

    static let preloadedLevelNames = ["Blackrock Mountain", "Happy Land", "Big Block", "Cosmic Horror"]

    static func createPreloadedLevel1() -> Board {
        var board = Board(name: preloadedLevelNames[0], objArr: [], isProtected: true)

        for i in 0..<8 {
            for j in 0..<6 {
                board.objArr.append(
                    EncodableObject(
                        xcoord: 40 + Double(i * 90),
                        ycoord: 200 + Double(j * 100),
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: (i + j).isMultiple(of: 2)
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )
            }
        }
        return board
    }

    static func createPreloadedLevel2() -> Board {
        var board = Board(name: preloadedLevelNames[1], objArr: [], isProtected: true)
        for i in 1..<8 {
            board.objArr.append(
                EncodableObject(
                    xcoord: 40 + Double(i * 90), ycoord: 80 + Double(i * 90),
                    width: GameBoardView.DEFAULT_OBJ_LENGTH,
                    height: GameBoardView.DEFAULT_OBJ_LENGTH,
                    type: i.isMultiple(of: 2)
                        ? GameObject.Types.bluePeg.rawValue
                        : GameObject.Types.orangePeg.rawValue
                )
            )
            if i == 4 {
                board.objArr.append(
                    EncodableObject(
                        xcoord: 130, ycoord: 440,
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: i.isMultiple(of: 2)
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )
                board.objArr.append(
                    EncodableObject(
                        xcoord: 750, ycoord: 440,
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: i.isMultiple(of: 2)
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )
                continue
            }
            board.objArr.append(
                EncodableObject(
                    xcoord: 40 + Double(i * 90), ycoord: 9.0 * 90.0 - Double(i * 90),
                    width: GameBoardView.DEFAULT_OBJ_LENGTH,
                    height: GameBoardView.DEFAULT_OBJ_LENGTH,
                    type: i.isMultiple(of: 2)
                        ? GameObject.Types.bluePeg.rawValue
                        : GameObject.Types.orangePeg.rawValue
                )
            )
        }

        return board
    }

    static func createPreloadedLevel3() -> Board {
        var board = Board(name: preloadedLevelNames[2], objArr: [], isProtected: true)

        for i in 0..<12 {
            for j in 0..<10 {
                board.objArr.append(
                    EncodableObject(
                        xcoord: 40 + Double(i * 60),
                        ycoord: 200 + Double(j * 60),
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: (i + j).isMultiple(of: 2)
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )
            }
        }
        return board
    }

    static func createPreloadedLevel4() -> Board {
        var board = Board(name: preloadedLevelNames[3], objArr: [], isProtected: true)

        board.objArr.append(
            EncodableObject(
                xcoord: 503.5,
                ycoord: 370.5,
                width: 163,
                height: 163,
                type: GameObject.Types.spookyPeg.rawValue
            )
        )

        board.objArr.append(
            EncodableObject(
                xcoord: 306,
                ycoord: 369.5,
                width: 163,
                height: 163,
                type: GameObject.Types.spookyPeg.rawValue
            )
        )

        board.objArr.append(
            EncodableObject(
                xcoord: 401.5,
                ycoord: 490,
                width: 92,
                height: 92,
                type: GameObject.Types.block.rawValue
            )
        )
        let yCoord = [579.5, 609, 638, 659.5, 647.5, 620, 599.5]
        let xCoord = [271, 302, 341.5, 381.5, 422.5, 461, 498.5]

        for i in 0..<yCoord.count {
            board.objArr.append(
                EncodableObject(
                    xcoord: xCoord[i],
                    ycoord: yCoord[i],
                    width: GameBoardView.DEFAULT_OBJ_LENGTH,
                    height: GameBoardView.DEFAULT_OBJ_LENGTH,
                    type: GameObject.Types.orangePeg.rawValue
                )
            )
        }

        return board
    }

    static func createPreloadedLevels() -> [Board] {
        var arr: [Board] = []
        arr.append(createPreloadedLevel1())
        arr.append(createPreloadedLevel2())
        arr.append(createPreloadedLevel3())
        arr.append(createPreloadedLevel4())
        return arr
    }

    static func loadBoardList() -> BoardList {
        // Decode data to object
        guard let boardList =
            UserDefaults.standard.value(forKey: PersistenceUtils.databaseUserDefaultKey) as? Data else {
                var boardList = BoardList(boards: [:])

                var index = 0
                for i in createPreloadedLevels() {
                    boardList.boards["preloaded" + String(index)] = i
                    index += 1
                }

                return boardList
        }

        do {
            var decodedBoardList = try JSONDecoder().decode(BoardList.self, from: boardList)

            var index = 0
            for i in createPreloadedLevels() {
                decodedBoardList.boards["preloaded" + String(index)] = i
                index += 1
            }

            return decodedBoardList
        } catch {
            print(error)
            return BoardList(boards: [:])
        }
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
            case is SpookyPeg:
                objType = GameObject.Types.spookyPeg.rawValue
            case is KaboomPeg:
                objType = GameObject.Types.kaboomPeg.rawValue
            case is TriangleBlock:
                objType = GameObject.Types.block.rawValue
            default:
                continue
            }

            board.objArr.append(
                EncodableObject(
                    xcoord: obj.physicsBody.coordinates.x,
                    ycoord: obj.physicsBody.coordinates.y,
                    width: obj.boundingBox.width,
                    height: obj.boundingBox.height,
                    type: objType
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
                        radius: obj.width / 2
                    )
                )
            case GameObject.Types.orangePeg.rawValue:
                gameObjBoard.append(
                    OrangePeg(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        radius: obj.width / 2
                    )
                )
            case GameObject.Types.spookyPeg.rawValue:
                gameObjBoard.append(
                    SpookyPeg(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        radius: obj.width / 2
                    )
                )
            case GameObject.Types.kaboomPeg.rawValue:
                gameObjBoard.append(
                    KaboomPeg(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        radius: obj.width / 2
                    )
                )
            case GameObject.Types.block.rawValue:
                gameObjBoard.append(
                    TriangleBlock(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        radius: obj.width / 2
                    )
                )

            default:
                continue
            }
        }
        return gameObjBoard
    }

}
