//
//  pegglegameApp.swift
//  pegglegame
//
//  Created by kevin chua on 18/1/22.
//

import SwiftUI
@main
struct PegglegameApp: App {
    var body: some Scene {
        WindowGroup {
            LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
        }
    }
}
