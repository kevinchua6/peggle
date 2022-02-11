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

    @State private var levelName: String = ""
    @State private var showLoadPopover = false

    // Check changes in keyboard to adjust pegs accordingly
    @ObservedObject var keyboardResponder = KeyboardResponder()

    // Properties of the placeholder
    @StateObject private var placeholderObj =
        PlaceholderObj(imageName: BluePeg.imageName, object: BluePeg(coordinates: CGPoint(x: 0, y: 0)), isVisible: false)

    var body: some View {
        NavigationView {
            VStack {
                generateGameBoardView()
                generateBottomBarView()
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
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func generateGameBoardView() -> some View {
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
    
    private func dragObjGesture(gameObjectImage: String,  gameObject: GameObject, bounds: CGRect) -> ExclusiveGesture<_EndedGesture<LongPressGesture>, _EndedGesture<_ChangedGesture<DragGesture>>> {
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

    private func generateMenuBarView() -> some View {
        HStack {
            Button(action: load) {
                Text("LOAD")
            }
            .sheet(isPresented: $showLoadPopover) {
                generateLoadLevelView()
            }
            Button(action: save) {
                Text("SAVE")
            }
            Button(action: reset) {
                Text("RESET")
            }
            TextField("Level Name", text: $levelName)
                .textFieldStyle(.roundedBorder)
            NavigationLink(destination: LazyView {
                StartGameView(startGameViewModel: StartGameViewModel(objArr: levelDesignerViewModel.objArr))
            }) {
                Text("START")
            }
        }
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private func generateLoadLevelView() -> some View {
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

    private func generateBottomBarView() -> some View {
        VStack {
            generateSelectionBarView()
            generateMenuBarView()
        }
        .background(Color.white)
    }

    private func generateSelectionBarView() -> some View {
        HStack {
            generateCreatePegButtonView(selection: .add(.blue), imageName: BluePeg.imageName)
            generateCreatePegButtonView(selection: .add(.orange), imageName: OrangePeg.imageName)
            Spacer()
            generateDeleteButtonView()
        }
        .padding(.horizontal, 8)
    }

    // Delete button
    private func generateDeleteButtonView() -> some View {
        Button(action: {
            levelDesignerViewModel.selectionMode = .delete
        }, label: {
            Image("DeleteButton")
                .resizable()
                .frame(width: 100, height: 100)
                .opacity(levelDesignerViewModel.selectionMode == .delete ? 1 : 0.5)
        })
    }

    private func generateCreatePegButtonView
        (selection: LevelDesignerViewModel.SelectionMode, imageName: String) -> some View {
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
