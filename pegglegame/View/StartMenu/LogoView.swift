//
//  LogoView.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        VStack {
            Text("Peggle")
                .foregroundColor(.blue)
                .font(.custom("Noteworthy-Bold", size: 210))
            Text("Evolved")
                .foregroundColor(.indigo)
                .font(.custom("Noteworthy-Bold", size: 80))
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
