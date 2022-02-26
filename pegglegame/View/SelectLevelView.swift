//
//  SelectLevelView.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import SwiftUI

struct SelectLevelView: View {
    @ObservedObject var selectLevelViewModel: SelectLevelViewModel
    @ObservedObject var gameEffectViewModel: GameEffectViewModel

    var body: some View {
        generateLoadLevelView()
    }

    @ViewBuilder
    private func generateLoadLevelView() -> some View {
        if selectLevelViewModel.boardList.boards.isEmpty {
            Text("No levels currently! Go to the Level Designer to create a level!")
                .font(.title)
                .multilineTextAlignment(.center)
        } else {
            VStack {
                VStack {
                    Text("Select a level with mode:")
                        .font(.title)
                    Picker(gameEffectViewModel.effect.rawValue, selection: $gameEffectViewModel.effect) {
                        ForEach(Effects.allCases, id: \.self) {
                            Text($0.rawValue)
                                .font(.system(size: 20))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                }
                .padding()

                List {
                    ForEach(selectLevelViewModel.boardList.toSortedArray(), id: \.name) { board in
                        NavigationLink(destination: LazyView {
                            StartGameView(
                                startGameViewModel: StartGameViewModel(
                                    objArr: PersistenceUtils.decodeBoardToGameObjArr(board: board),
                                    effect: gameEffectViewModel.effect
                                )
                            )
                        }) {
                            Text(board.name)
                        }
                    }
                }
            }
        }
    }
}

struct SelectLevelView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLevelView(selectLevelViewModel: SelectLevelViewModel(), gameEffectViewModel: GameEffectViewModel())
    }
}
