//
//  LazyView.swift
//  pegglegame
//
//  Created by kevin chua on 4/2/22.
//

import SwiftUI

// Adapted from https://stackoverflow.com/a/61234030
struct LazyView<Content: View>: View {
    private let build: () -> Content

    init(_ build: @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
