//
//  Board.swift
//  pegglegame
//
//  Created by kevin chua on 27/1/22.
//

import UIKit

// Represents a level when saving and loading
struct Board: Codable {
    var name: String
    var objArr: [EncodableObject]
    var isProtected: Bool = false
}
