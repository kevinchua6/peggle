//
//  SelectLevelView.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import SwiftUI

struct SelectLevelView: View {
    @ObservedObject var selectLevelViewModel: SelectLevelViewModel

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
                Text("Select a level:")
                    .font(.title)
                    .padding()
                List {
                    ForEach(selectLevelViewModel.boardList.toSortedArray(), id: \.name) { board in
                        NavigationLink(destination: LazyView {
                            StartGameView(startGameViewModel: StartGameViewModel(objArr: PersistenceUtils.decodeBoardToGameObjArr(board: board)))
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
        SelectLevelView(selectLevelViewModel: SelectLevelViewModel())
    }
}
