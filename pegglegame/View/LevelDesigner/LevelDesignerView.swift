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

    var body: some View {
        VStack(alignment: .leading) {
                GameBoardView(
                    levelDesignerViewModel: levelDesignerViewModel,
                    placeholderObj: levelDesignerViewModel.placeholderObj
                )
                BottomBarView(levelDesignerViewModel: levelDesignerViewModel,
                              placeholderObj: levelDesignerViewModel.placeholderObj
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
