//
//  BottomBarView.swift
//  pegglegame
//
//  Created by kevin chua on 12/2/22.
//

import SwiftUI

struct BottomBarView: View {
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
            NavigationLink(destination: LazyView {
                StartGameView(startGameViewModel: StartGameViewModel(objArr: levelDesignerViewModel.objArr))
            }) {
                Text("START")
            }
        }
        .padding(.horizontal, 8)
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
}
