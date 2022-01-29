//
//  PlaceholderObj.swift
//  pegglegame
//
//  Created by kevin chua on 23/1/22.
//

import Foundation

/// represents the object which allows the user to tell the position of the object
/// before placing it during placement and deletion
class PlaceholderObj: ObservableObject {
    @Published var imageName: String

    @Published var object: GameObject
    @Published var isValid: Bool
    @Published var isVisible: Bool

    init(imageName: String, object: GameObject) {
        self.imageName = imageName
        self.object = object
        self.isValid = true
        self.isVisible = true
    }
}
