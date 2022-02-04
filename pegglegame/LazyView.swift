//
//  LazyView.swift
//  pegglegame
//
//  Created by kevin chua on 4/2/22.
//

import SwiftUI

struct LazyView<Content: View>: View {
    private let build: () -> Content

    init(_ build: @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
