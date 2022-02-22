//
//  SelectLevelViewModel.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import Foundation

class SelectLevelViewModel: ObservableObject {
    @Published var objArr: [GameObject] = []
    @Published var boardList = PersistenceUtils.loadBoardList()
}
