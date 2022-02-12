//
//  GameBoardView.swift
//  pegglegame
//
//  Created by kevin chua on 12/2/22.
//

import SwiftUI
import CoreGraphics

struct GameBoardView: View {
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel
    // Check changes in keyboard to adjust pegs accordingly
    @ObservedObject var keyboardResponder = KeyboardResponder()

    @StateObject var placeholderObj: PlaceholderObj

    var body: some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .gesture(
                        placePegGesture(bounds: bounds)
                    )
                    .ignoresSafeArea(.keyboard)
                ForEach(levelDesignerViewModel.objArr) { entity in
                    generateGameObjectView(gameObject: entity, bounds: bounds)
                }
                generatePlaceholderObjView()
            }
        }
    }

    private func placePegGesture(bounds: CGRect) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if keyboardResponder.isKeyboardOpen {
                    return
                }
                placeholderObj.isVisible = true
                placeholderObj.object.physicsBody.coordinates = value.location
                self.placeholderObj.isValid =
                    levelDesignerViewModel.isValidPlacement(
                        object: self.placeholderObj.object, bounds: bounds
                    )
            }
            .onEnded({ value in
                if keyboardResponder.isKeyboardOpen {
                    return
                }
                placeholderObj.isVisible = false
                // Add peg at that location if it is valid
                if self.placeholderObj.isValid {
                    levelDesignerViewModel.placeObj(at: value.location)
                }
                self.placeholderObj.isValid = true
            })
    }

    @ViewBuilder
    private func generateGameObjectView(gameObject: GameObject, bounds: CGRect) -> some View {
        if let gameObjectImage = gameObject.imageName {
            Image(gameObjectImage)
                .resizable()
                .frame(width: 40, height: 40)
                // we want it to adjust by the keyboard amount
                .position(gameObject.physicsBody.coordinates)
                .offset(y: -keyboardResponder.currentHeight * 0.9)
                .gesture(
                    dragObjGesture(gameObjectImage: gameObjectImage, gameObject: gameObject, bounds: bounds)
                )
        }
    }

    private func dragObjGesture(gameObjectImage: String,
                                gameObject: GameObject,
                                bounds: CGRect
    ) -> ExclusiveGesture<_EndedGesture<LongPressGesture>, _EndedGesture<_ChangedGesture<DragGesture>>> {

        ExclusiveGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded({ _ in
                    levelDesignerViewModel.deleteObj(obj: gameObject)
                }),
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if keyboardResponder.isKeyboardOpen {
                        return
                    }

                    levelDesignerViewModel.dragObj(
                        obj: placeholderObj.object,
                        from: gameObject.physicsBody.coordinates, by: value.translation
                    )

                    // The current peg's location stays there, except the
                    // placeholder peg will follow a translation of the current location
                    placeholderObj.imageName = gameObjectImage
                    placeholderObj.isVisible = true

                    placeholderObj.isValid = levelDesignerViewModel.isValidDrag(
                        object: placeholderObj.object, originalObj: gameObject, bounds: bounds
                    )
                }
                .onEnded({ _ in
                    if keyboardResponder.isKeyboardOpen {
                        return
                    }

                    placeholderObj.isVisible = false
                    // Add peg at that location if it is valid
                    // And delete the current peg
                    if placeholderObj.isValid {
                        levelDesignerViewModel.deleteObj(obj: gameObject)
                        levelDesignerViewModel.placeObj(at: placeholderObj.object.physicsBody.coordinates)
                    }
                    self.placeholderObj.isValid = true
                })
            )
    }

    @ViewBuilder
    private func generatePlaceholderObjView() -> some View {
        if case .add = levelDesignerViewModel.selectionMode {
            // If not visible or not in add mode, hide it
            if self.placeholderObj.isVisible {
                // If not valid, show red
                if !placeholderObj.isValid {
                    Image(placeholderObj.imageName)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .opacity(0.3)
                        .position(placeholderObj.object.physicsBody.coordinates)
                        .foregroundColor(.red)
                }
                Image(placeholderObj.imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .opacity(0.3)
                    .position(placeholderObj.object.physicsBody.coordinates)
            }
        }
    }
}
