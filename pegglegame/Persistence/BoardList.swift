//
//  BoardList.swift
//  pegglegame
//
//  Created by kevin chua on 28/1/22.
//

// Represents a list of boards
struct BoardList: Codable {
    var boards: [String: Board]

    func toSortedArray() -> [Board] {
        var sortedArray: [Board] = []
        for board in boards.values {
            sortedArray.append(board)
        }
        return sortedArray.sorted(by: { $1.name > $0.name })
    }
}
