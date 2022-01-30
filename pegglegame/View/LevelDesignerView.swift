//
//  LevelDesignerView.swift
//  pegglegame
//
//  Created by kevin chua on 20/1/22.
//

import SwiftUI

// swiftlint:disable identifier_name
struct LevelDesignerView: View {
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel

    @State private var levelName: String = ""
    @State private var showLoadPopover = false

    // Check changes in keyboard to adjust pegs accordingly
    @ObservedObject var keyboardResponder = KeyboardResponder()

    // Properties of the placeholder
    @StateObject private var placeholderObj =
    PlaceholderObj(imageName: BluePeg.imageName, object: BluePeg(coordinates: CGPoint(x: -100, y: -100), radius: 20.0))

    var body: some View {
        VStack {
            GameBoardView()
            SelectionBarView()
            MenuBarView()
        }
        .alert(isPresented: $levelDesignerViewModel.alert.visible) {
            Alert(title: Text(levelDesignerViewModel.alert.title), message: Text(levelDesignerViewModel.alert.message))
        }
    }

    private func GameBoardView() -> some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: .local)
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .gesture(
                        placePegGesture(bounds: bounds)
                    )
                ForEach(levelDesignerViewModel.objArr) { entity in
                    GameObjectView(gameObject: entity, bounds: bounds)
                }
                PlaceholderObjView()
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

    private func GameObjectView(gameObject: GameObject, bounds: CGRect) -> some View {
        Image(gameObject.imageName)
            .resizable()
            .frame(width: 40, height: 40)
            // we want it to adjust by the keyboard amount
            .position(x: gameObject.physicsBody.coordinates.x, y: gameObject.physicsBody.coordinates.y)
            .offset(y: -keyboardResponder.currentHeight * 0.9)
            .gesture(
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
                            placeholderObj.imageName = gameObject.imageName
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
            )
    }

    @ViewBuilder
    private func PlaceholderObjView() -> some View {
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

    private func MenuBarView() -> some View {
        HStack {
            Button(action: load) {
                Text("LOAD")
            }
            .sheet(isPresented: $showLoadPopover) {
                LoadLevelView()
            }
            Button(action: save) {
                Text("SAVE")
            }
            Button(action: reset) {
                Text("RESET")
            }
            TextField("Level Name", text: $levelName)
                .textFieldStyle(.roundedBorder)
            Button(action: start) {
                Text("START")
            }
        }
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func LoadLevelView() -> some View {
        if levelDesignerViewModel.boardList.boards.isEmpty {
            Text("No levels currently! Go save a level by pressing the SAVE button!")
                .font(.title)
                .multilineTextAlignment(.center)
        } else {
            List {
                ForEach(levelDesignerViewModel.boardList.toSortedArray(), id: \.name) { board in
                    Button(action: {
                        levelDesignerViewModel.objArr = PersistenceUtils.decodeBoardToGameObjArr(board: board)
                        showLoadPopover = false
                    }, label: {
                        Text(board.name)
                    })
                }
            }
        }
    }

    private func SelectionBarView() -> some View {
        HStack {
            CreatePegButtonView(selection: .add(.blue), imageName: BluePeg.imageName)
            CreatePegButtonView(selection: .add(.orange), imageName: OrangePeg.imageName)
            Spacer()
            DeleteButtonView()
        }
        .padding(.horizontal, 8)
    }

    // Delete button
    private func DeleteButtonView() -> some View {
        Button(action: {
            levelDesignerViewModel.selectionMode = .delete
        }, label: {
            Image("DeleteButton")
                .resizable()
                .frame(width: 100, height: 100)
                .opacity(levelDesignerViewModel.selectionMode == .delete ? 1 : 0.5)
        })
    }

    private func CreatePegButtonView(selection: LevelDesignerViewModel.SelectionMode, imageName: String) -> some View {
        Button(action: {
            levelDesignerViewModel.selectionMode = selection
            placeholderObj.imageName = imageName
        }, label: {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .opacity(levelDesignerViewModel.selectionMode == selection ? 1 : 0.5)
        })
    }

    private func reset() {
        levelDesignerViewModel.objArr = []
    }

    private func save() {
        do {
            try levelDesignerViewModel.saveBoard(gameObjArr: levelDesignerViewModel.objArr, as: levelName)
        } catch {
            // If have error in saving, delete the database and print the error
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(error)
        }
    }

    private func load() {
        levelDesignerViewModel.boardList = PersistenceUtils.loadBoardList()
        showLoadPopover = true
    }

    private func start() {

    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
    }
}
