//
//  PersistenceUtils.swift
//  pegglegame
//
//  Created by kevin chua on 27/1/22.
//

import SwiftUI

class PersistenceUtils {
    static let databaseUserDefaultKey = "boardList"

    static let preloadedLevelNames = ["Blackrock Mountain", "Happy Land", "Big Block"]

    static func createPreloadedLevel1() -> Board {
        var board = Board(name: preloadedLevelNames[0], objArr: [], isProtected: true)

        for i in 0..<9 {
            for j in 0..<7 {
                board.objArr.append(
                    EncodableObject(
                        xcoord: 40 + Double(i * 90),
                        ycoord: 200 + Double(j * 100),
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: (i + j) % 2 == 0
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

        for i in 0..<9 {
            board.objArr.append(
                EncodableObject(
                    xcoord: 40 + Double(i * 90),
                    ycoord: 80 + Double(i * 90),
                    width: GameBoardView.DEFAULT_OBJ_LENGTH,
                    height: GameBoardView.DEFAULT_OBJ_LENGTH,
                    type: i % 2 == 0
                        ? GameObject.Types.bluePeg.rawValue
                        : GameObject.Types.orangePeg.rawValue
                )
            )

            if i == 4 {
                board.objArr.append(
                    EncodableObject(
                        xcoord: 130,
                        ycoord: 440,
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: i % 2 == 0
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )

                board.objArr.append(
                    EncodableObject(
                        xcoord: 750,
                        ycoord: 440,
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: i % 2 == 0
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )

                continue
            }

            board.objArr.append(
                EncodableObject(
                    xcoord: 40 + Double(i * 90),
                    ycoord: 9.0 * 90.0 - Double(i * 90),
                    width: GameBoardView.DEFAULT_OBJ_LENGTH,
                    height: GameBoardView.DEFAULT_OBJ_LENGTH,
                    type: i % 2 == 0
                        ? GameObject.Types.bluePeg.rawValue
                        : GameObject.Types.orangePeg.rawValue
                )
            )
        }

        return board
    }

    static func createPreloadedLevel3() -> Board {
        var board = Board(name: preloadedLevelNames[2], objArr: [], isProtected: true)

        for i in 0..<13 {
            for j in 0..<10 {
                board.objArr.append(
                    EncodableObject(
                        xcoord: 40 + Double(i * 60),
                        ycoord: 200 + Double(j * 60),
                        width: GameBoardView.DEFAULT_OBJ_LENGTH,
                        height: GameBoardView.DEFAULT_OBJ_LENGTH,
                        type: (i + j) % 2 == 0
                            ? GameObject.Types.bluePeg.rawValue
                            : GameObject.Types.orangePeg.rawValue
                    )
                )
            }
        }
        return board
    }

    static func loadBoardList() -> BoardList {
        // Decode data to object
        guard let boardList =
                UserDefaults.standard.value(forKey: PersistenceUtils.databaseUserDefaultKey) as? Data else {
                    var boardList = BoardList(boards: [:])

                    boardList.boards["preloaded1"] = createPreloadedLevel1()
                    boardList.boards["preloaded2"] = createPreloadedLevel2()
                    boardList.boards["preloaded3"] = createPreloadedLevel3()

            return BoardList(boards: [:])
        }

        do {
            var decodedBoardList = try JSONDecoder().decode(BoardList.self, from: boardList)
            decodedBoardList.boards["preloaded1"] = createPreloadedLevel1()
            decodedBoardList.boards["preloaded2"] = createPreloadedLevel2()
            decodedBoardList.boards["preloaded3"] = createPreloadedLevel3()

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
                // defensive checks
                if obj.width != obj.height {
                    continue
                }

                gameObjBoard.append(
                    BluePeg(
                        coordinates: CGPoint(x: obj.xcoord, y: obj.ycoord),
                        radius: obj.width / 2
                    )
                )
            case GameObject.Types.orangePeg.rawValue:
                // defensive checks
                if obj.width != obj.height {
                    continue
                }

                gameObjBoard.append(
                    OrangePeg(
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
