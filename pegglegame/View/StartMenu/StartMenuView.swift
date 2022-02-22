//
//  StartMenuView.swift
//  pegglegame
//
//  Created by kevin chua on 22/2/22.
//

import SwiftUI

struct StartMenuView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                LogoView()
                generateStartButtonView()
                    .padding(.bottom, 300)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func generateStartButtonView() -> some View {
        VStack(spacing: 30) {
            NavigationLink(destination: LazyView {
                LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
            }) {
                Text("START GAME")
                    .padding()
                    .background(.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            
            NavigationLink(destination: LazyView {
                LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())
            }) {
                Text("LEVEL DESIGNER")
                    .padding()
                    .background(.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
        }
    }
    
}

struct StartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StartMenuView()
    }
}
