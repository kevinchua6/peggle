//
//  GameBoardView.swift
//  pegglegame
//
//  Created by kevin chua on 12/2/22.
//

import SwiftUI
import CoreGraphics

struct GameBoardView: View {
    static let DEFAULT_OBJ_LENGTH = 40.0
    static let PLACEHOLDER_OPACITY = 0.3

    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel
    // Check changes in keyboard to adjust pegs accordingly
    @ObservedObject var keyboardResponder = KeyboardResponder()

    @StateObject var placeholderObj: PlaceholderObj

    var body: some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            ZStack {
                ForEach(levelDesignerViewModel.objArr) { entity in
                    generateGameObjectView(gameObject: entity, bounds: bounds)
                }

                if let obj = levelDesignerViewModel.selectedObj {
                    SelectObjectView(obj: obj, bounds: bounds, levelDesignerViewModel: levelDesignerViewModel)
                        .offset(y: -keyboardResponder.currentHeight * 0.9)
                }

                generatePlaceholderObjView(placeholderObj: placeholderObj)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.keyboard),
                alignment: .leading
            )
            .gesture(
                placePegGesture(bounds: bounds)
            )
        }
    }

    private func placePegGesture(bounds: CGRect) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if keyboardResponder.isKeyboardOpen {
                    return
                }
                placeholderObj.isVisible = true
                placeholderObj.object.coordinates = value.location

                placeholderObj.object.physicsBody.setLength(
                    length: GameBoardView.DEFAULT_OBJ_LENGTH
                )

                self.placeholderObj.isValid =
                    levelDesignerViewModel.isValidPlacement(
                        physicsBody: self.placeholderObj.object.physicsBody, bounds: bounds
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
                .frame(width: gameObject.physicsBody.boundingBox.width,
                       height: gameObject.physicsBody.boundingBox.width
                )
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
                    levelDesignerViewModel.deleteIfButtonSelected(gameObject: gameObject)

                    if keyboardResponder.isKeyboardOpen {
                        return
                    }

                    if let gameObjImageName = gameObject.imageName {
                        placeholderObj.imageName = gameObjImageName
                    }

                    placeholderObj.object.physicsBody.setLength(
                        length: gameObject.physicsBody.boundingBox.height
                    )

                    levelDesignerViewModel.dragObj(
                        obj: placeholderObj.object,
                        from: gameObject.physicsBody.coordinates,
                        by: value.translation
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

                    // on tap, select it
                    levelDesignerViewModel.selectObj(obj: gameObject)

                    if placeholderObj.isVisible && placeholderObj.isValid {
                        levelDesignerViewModel.moveObj(obj: gameObject, to: placeholderObj.object.coordinates)
                    }

                    placeholderObj.isVisible = false
                    self.placeholderObj.isValid = true

                    levelDesignerViewModel.deleteIfButtonSelected(gameObject: gameObject)
                })
            )
    }

    @ViewBuilder
    private func generatePlaceholderObjView(placeholderObj: PlaceholderObj) -> some View {
        if levelDesignerViewModel.selectionMode != LevelDesignerViewModel.SelectionMode.delete {
            if self.placeholderObj.isVisible {
                if !placeholderObj.isValid {
                    Image(placeholderObj.imageName)
                        .renderingMode(.template)
                        .resizable()
                        .frame(
                            width: placeholderObj.object.physicsBody.boundingBox.width,
                            height: placeholderObj.object.physicsBody.boundingBox.height
                        )
                        .opacity(GameBoardView.PLACEHOLDER_OPACITY)
                        .position(placeholderObj.object.physicsBody.coordinates)
                        .foregroundColor(.red)
                }
                Image(placeholderObj.imageName)
                    .resizable()
                    .frame(
                        width: placeholderObj.object.physicsBody.boundingBox.width,
                        height: placeholderObj.object.physicsBody.boundingBox.height
                    )
                    .opacity(GameBoardView.PLACEHOLDER_OPACITY)
                    .position(placeholderObj.object.physicsBody.coordinates)
            }
        }
    }
}
