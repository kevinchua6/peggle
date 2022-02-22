//
//  LevelDesignerView.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import SwiftUI
import CoreGraphics

struct LevelDesignerView: View {
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel

    // Properties of the placeholder
    @StateObject private var placeholderObj =
        PlaceholderObj(
            imageName: BluePeg.imageName,
            object: BluePeg(coordinates: CGPoint(x: 0, y: 0),
                            name: "placeholder"),
            isVisible: false
        )

    var body: some View {
        VStack(alignment: .leading) {
                GameBoardView(
                    levelDesignerViewModel: levelDesignerViewModel,
                    placeholderObj: placeholderObj
                )
                BottomBarView(levelDesignerViewModel: levelDesignerViewModel,
                              placeholderObj: placeholderObj
                )
            }
            .alert(isPresented: $levelDesignerViewModel.alert.visible) {
                Alert(
                    title:
                        Text(
                            levelDesignerViewModel.alert.title
                        ),
                    message: Text(levelDesignerViewModel.alert.message)
                )
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
