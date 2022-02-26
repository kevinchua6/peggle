//
//  BottomBarView.swift
//  pegglegame
//
//  Created by kevin chua on 12/2/22.
//

import SwiftUI

struct BottomBarView: View {
    let SIDE_PADDING = 8.0
    let SELECTED_OPACITY = 1.0
    let NOT_SELECTED_OPACITY = 0.5
    let PEG_BUTTON_LENGTH = 100.0

    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel

    @State private var showLoadPopover = false
    @State private var levelName: String = ""

    @StateObject var placeholderObj: PlaceholderObj

    var body: some View {
        VStack {
            generateSelectionBarView()
            generateMenuBarView()
        }
        .background(Color.white)
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
            generateStartButton()
        }
        .padding(.horizontal, SIDE_PADDING)
    }

    @ViewBuilder
    private func generateStartButton() -> some View {
        if levelDesignerViewModel
            .getCount(of: OrangePegComponent.self) <= 0 {
            Button(action: {
                levelDesignerViewModel.showAlert(title: "Error",
                                                 message: "You can't start a level that has no orange pegs!"
                )
            }) {
                Text("START")
                    .foregroundColor(.red)
            }
        } else {
            NavigationLink(destination: LazyView {
                StartGameView(startGameViewModel:
                                StartGameViewModel(objArr: levelDesignerViewModel.objArr, effect: .normal))
            }) {
                Text("START")
            }
        }
    }

    private func generateSelectionBarView() -> some View {
        HStack {
            generateCreateObjButtonView(selection: .add(.blue), imageName: BluePeg.imageName,
                                        count: levelDesignerViewModel.getCount(of: BluePegComponent.self))
            generateCreateObjButtonView(selection: .add(.orange), imageName: OrangePeg.imageName,
                                        count: levelDesignerViewModel.getCount(of: OrangePegComponent.self))
            generateCreateObjButtonView(selection: .add(.kaboom), imageName: KaboomPeg.imageName,
                                        count: levelDesignerViewModel.getCount(of: KaboomPegComponent.self))
            generateCreateObjButtonView(selection: .add(.spooky), imageName: SpookyPeg.imageName,
                                        count: levelDesignerViewModel.getCount(of: SpookyPegComponent.self))
            generateCreateObjButtonView(selection: .addTriangleBlock, imageName: TriangleBlock.imageName,
                                        count: levelDesignerViewModel.getCount(of: TriangleBlockComponent.self))
            Spacer()
            generateDeleteButtonView()
        }
        .padding(.horizontal, SIDE_PADDING)
    }

    @ViewBuilder
    private func generateLoadLevelView() -> some View {
        if levelDesignerViewModel.boardList.boards.isEmpty {
            Text("No levels currently! Go save a level by pressing the SAVE button!")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
        } else {
            VStack {
                Text("Select a level:")
                    .font(.title)
                List {
                    ForEach(levelDesignerViewModel.boardList.toSortedArray(), id: \.name) { board in
                        Button(action: {
                            levelDesignerViewModel.objArr = PersistenceUtils.decodeBoardToGameObjArr(board: board)
                            levelName = board.name
                            showLoadPopover = false
                        }, label: {
                            HStack {
                                Text(board.name)

                                if board.isProtected == true {
                                    Spacer()
                                    Text("Default Level")
                                }
                            }

                        })
                    }
                }
            }
        }
    }

    // Delete button
    private func generateDeleteButtonView() -> some View {
        Button(action: {
            levelDesignerViewModel.selectionMode = .delete
        }, label: {
            Image("DeleteButton")
                .resizable()
                .frame(width: PEG_BUTTON_LENGTH, height: PEG_BUTTON_LENGTH)
                .opacity(levelDesignerViewModel.selectionMode == .delete ? SELECTED_OPACITY : NOT_SELECTED_OPACITY)
        })
    }

    private func generateCreateObjButtonView
    (selection: LevelDesignerViewModel.SelectionMode, imageName: String, count: Int) -> some View {
        ZStack {
            Button(action: {
                levelDesignerViewModel.selectionMode = selection
                placeholderObj.imageName = imageName
            }, label: {
                Image(imageName)
                    .resizable()
                    .frame(width: PEG_BUTTON_LENGTH, height: PEG_BUTTON_LENGTH)
                    .opacity(levelDesignerViewModel.selectionMode == selection
                             ? SELECTED_OPACITY : NOT_SELECTED_OPACITY)
            })
            Text("\(count)")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 5)
        }

    }

    private func reset() {
        levelDesignerViewModel.objArr = []
        levelDesignerViewModel.deselectObj()
    }

    private func save() {
        if PersistenceUtils.preloadedLevelNames.contains(levelName) {
            levelDesignerViewModel.showAlert(title: "Error", message: "You can't override default levels!")
            return
        }

        if levelDesignerViewModel
            .getCount(of: OrangePegComponent.self) <= 0 {
                levelDesignerViewModel.showAlert(title: "Error",
                                                 message: "You can't save a level that has no orange pegs!"
                )
            return
        }

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
        levelDesignerViewModel.deselectObj()
        showLoadPopover = true
    }
}
